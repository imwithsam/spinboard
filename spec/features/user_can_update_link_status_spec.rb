require "rails_helper"

RSpec.feature "User can update link status", type: :feature do
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

  scenario "User can update new link status from unread to read", js: true do
    visit links_path

    click_link_or_button "Mark as Read"

    expect(page).to have_link("Mark as Unread")
  end
end
