require "uri"

class Link < ActiveRecord::Base
  validate :url_must_be_valid

  def url_must_be_valid
    uri = URI.parse(url)
    errors.add(:url, "must be valid") unless uri.kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    errors.add(:url, "must be valid")
  end
end
