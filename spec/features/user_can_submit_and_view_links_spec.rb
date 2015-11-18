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

  scenario "A new link defaults to an unread status" do
    visit links_path

    fill_in "Url", with: "http://badmotivator.io/"
    fill_in "Title", with: "Bad Motivator Blog"
    click_button "Submit"

    expect(page).to have_content("unread")
  end

  scenario "Submitting an invalid link results in an error message" do
    visit links_path

    fill_in "Url", with: "invalid#url"
    fill_in "Title", with: "Invalid URL"
    click_button "Submit"

    expect(page).to have_content("Unable to add link.")
    expect(page).to_not have_link("Invalid URL")
  end

  scenario "User can view only their links" do
    visit links_path

    fill_in "Url", with: "http://badmotivator.io/"
    fill_in "Title", with: "Bad Motivator Blog"
    click_button "Submit"

    expect(page).to have_link("Bad Motivator Blog")

    User.create(
      email_address: "samson2@example.com",
      password:      "password"
    )

    visit login_path
    fill_in "Email address", with: "samson2@example.com"
    fill_in "Password", with: "password"
    click_button "Submit"

    expect(page).to_not have_link("Bad Motivator Blog")
  end
end
