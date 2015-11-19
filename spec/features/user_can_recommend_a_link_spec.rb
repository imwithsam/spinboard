require "rails_helper"

RSpec.feature "User can recommend a link", type: :feature do
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

  scenario "User can email person after clicking 'recommend link'" do
    visit links_path

    click_link_or_button "Recommend Link"

    fill_in "Email address", with: "test@example.com"
    click_button "Submit"

    expect(page).to have_content("Your recommendation has been emailed to test@example.com!")
  end
end
