require "rails_helper"

describe "Register User" do
  it "new user" do
    visit root_path
    click_on "Registration"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "123456"
    fill_in "Password confirmation", with: "123456"
    click_on "Sign up"
    expect(page).to have_content "Welcome! You have signed up successfully."
  end

  it "with existing user in database" do
    user = create(:user)
    visit new_user_registration_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: user.password
    click_on "Sign up"
    expect(page).to have_content "Email has already been taken"
  end
end
