require "uri"

class Link < ActiveRecord::Base
  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
      :sorted_by,
      :read_status,
      :search_query
    ]
  )

  validate :url_must_be_valid
  before_save :create_short_link
  belongs_to :user

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      # Simple sort on the created_at column.
      # Make sure to include the table name to avoid ambiguous column names.
      # Joining on other tables is quite common in Filterrific, and almost
      # every ActiveRecord table has a 'created_at' column.
      order("links.created_at #{ direction }")
    when /^title_/
      # Simple sort on the title column
      order("LOWER(links.title) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  scope :read_status, lambda { |read_status|
    where("read = ?", read_status)
  }

  scope :search_query, lambda { |query|
    return nil  if query.blank?

    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)

    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conds = 1
    where(
      terms.map { |term|
        "(LOWER(links.title) ILIKE ?)"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }

  def self.options_for_read_status
    [true, false]
  end

  def self.options_for_sorted_by
    [
      ["Title (a-z)", "title_asc"],
      ["Title (z-a)", "title_desc"]
    ]
  end

  def status
    read ? "read" : "unread"
  end

private

  def url_must_be_valid
    uri = URI.parse(url)
    errors.add(:url, "must be valid") unless uri.kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    errors.add(:url, "must be valid")
  end

  def create_short_link
    shorty = ShortURL.shorten(url, :tinyurl)
    write_attribute(:short_url, shorty)
  end
end
