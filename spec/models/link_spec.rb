require 'rails_helper'

RSpec.describe Link, type: :model do
  context "with multiple links" do
    before do
      @link_1 = Link.create(
        url: "http://badmotivator.io/",
        title: "Bad Motivator Blog"
      )
      @link_2 = Link.create(
        url: "http://yahoo.com/",
        title: "Yahoo!"
      )
      @link_3 = Link.create(
        url: "http://lifehacker.com/",
        title: "LifeHacker"
      )
    end

    it "filters by search query" do
      query = "Bad"
      results = Link.search_query(query)

      expect(results.first.url).to eq("http://badmotivator.io/")
      expect(results.first.title).to eq("Bad Motivator Blog")
      expect(results.count).to eq(1)

      query = "Yahoo"
      results = Link.search_query(query)

      expect(results.first.url).to eq("http://yahoo.com/")
      expect(results.first.title).to eq("Yahoo!")
      expect(results.count).to eq(1)

      query = "Life"
      results = Link.search_query(query)

      expect(results.first.url).to eq("http://lifehacker.com/")
      expect(results.first.title).to eq("LifeHacker")
      expect(results.count).to eq(1)
    end

    it "filters by read status" do
      status = "read"
      results = Link.read_status(status)

      expect(results.count).to eq(0)

      status = "unread"
      results = Link.read_status(status)

      expect(results.count).to eq(3)

      @link_1.update(read: true)

      status = "read"
      results = Link.read_status(status)

      expect(results.count).to eq(1)

      status = "unread"
      results = Link.read_status(status)

      expect(results.count).to eq(2)
    end

    it "sorts by title ascending" do
      sort_option = "title_asc"
      results = Link.sorted_by(sort_option)

      expect(results.first.url).to eq("http://badmotivator.io/")
      expect(results.first.title).to eq("Bad Motivator Blog")
      expect(results.count).to eq(3)
    end

    it "sorts by title descending" do
      sort_option = "title_desc"
      results = Link.sorted_by(sort_option)

      expect(results.first.url).to eq("http://yahoo.com/")
      expect(results.first.title).to eq("Yahoo!")
      expect(results.count).to eq(3)
    end
  end

  context "with an invalid url" do
    it "does not allow it to be added" do
      link = Link.new(
        url: "bogus#url",
        title: "Bogus Link"
      )

      link.save

      expect(Link.count).to eq(0)
    end
  end

  context "with a valid url" do
    it "creates a TinyURL" do
      link = Link.new(
        url: "http://badmotivator.io/",
        title: "Bad Motivator Blog"
      )

      link.save

      expect(Link.first.short_url).to include("http://tinyurl.com/")
      expect(Link.count).to eq(1)
    end
  end
end
