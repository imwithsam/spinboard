require "rails_helper"

RSpec.feature "User can use short links", type: :feature do
  before do
    User.create(
      email_address: "samson@example.com",
      password:      "password"
    )

    visit login_path
    fill_in "Email address", with: "samson@example.com"
    fill_in "Password", with: "password"
    click_button "Submit"

    visit links_path
    fill_in "Url", with: "http://badmotivator.io/"
    fill_in "Title", with: "Bad Motivator Blog"
    click_button "Submit"
  end

  scenario "User can click on short link and be directed to original URL" do
    visit links_path

    find(".short-link").click

    expect(current_path).to eq("http://badmotivator.io/")
  end
end
