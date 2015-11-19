require "rails_helper"

RSpec.feature "User can edit links", type: :feature do
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

  scenario "User can click edit button and edit link" do
    visit links_path

    click_link_or_button "Edit"
    fill_in "Url", with: "http://newlink.com/"
    fill_in "Title", with: "New Link"
    click_button "Submit"

    expect(page).to have_link("New Link")
  end

  scenario "User cannot change url to an invalid url" do
    visit links_path

    click_link_or_button "Edit"
    fill_in "Url", with: "bad#url"
    fill_in "Title", with: "New Link"
    click_button "Submit"

    expect(page).to have_content("Unable to update link.")
    expect(page).to have_link("Bad Motivator Blog")
  end
end
