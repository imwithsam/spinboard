require "rails_helper"

RSpec.feature "Authenitcated user can submit and view links", type: :feature do
  before do
    User.create(
      email_address: "samson@example.com",
      password:      "password"
    )

    visit login_path
    fill_in "Email address", with: "samson@example.com"
    fill_in "Password", with: "password"
    click_button "Submit"
  end

  scenario "User can submit a link" do
    visit links_path

    fill_in "Url", with: "http://badmotivator.io/"
    fill_in "Title", with: "Bad Motivator Blog"
    click_button "Submit"

    expect(page).to have_link("Bad Motivator Blog")
  end
end
