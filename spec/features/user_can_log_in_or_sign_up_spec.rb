require "rails_helper"

RSpec.feature "Unauthenticated user can Log In or Sign Up", type: :feature do
  scenario "New user visits root and can sign up" do
    visit root_path

    click_link_or_button "Sign Up"
    fill_in "Email address", with: "samson@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Submit"

    expect(current_path).to eq(links_path)
    expect(page).to have_selector(:link_or_button, "Sign Out")
  end

  scenario "Existing user visits root and can log in" do
    User.create(
      email_address: "samson@example.com",
      password:      "password"
    )

    visit root_path

    click_link_or_button "Log In"
    fill_in "Email address", with: "samson@example.com"
    fill_in "Password", with: "password"
    click_button "Submit"

    expect(current_path).to eq(links_path)
    expect(page).to have_selector(:link_or_button, "Sign Out")
  end

  scenario "User can log out" do
    User.create(
      email_address: "samson@example.com",
      password:      "password"
    )

    visit root_path

    click_link_or_button "Log In"
    fill_in "Email address", with: "samson@example.com"
    fill_in "Password", with: "password"
    click_button "Submit"
    click_link_or_button "Sign Out"

    expect(current_path).to eq(login_path)
    expect(page).to have_selector(:link_or_button, "Log In")
  end

  scenario "User must be logged in to view links index" do
    visit links_path

    expect(current_path).to eq(login_path)
  end
end
