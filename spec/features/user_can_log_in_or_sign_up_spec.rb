require "rails_helper"

RSpec.feature "Unauthenticated user can Log In or Sign Up", type: :feature do
  scenario "User visits root and can sign up" do
    visit root_path

    fill_in "Email address", with: "Jane Doe"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Submit"

    expect(current_path).to eq(links_path)
    expect(page).to have_selector(:link_or_button, "Sign Out")
  end
end
