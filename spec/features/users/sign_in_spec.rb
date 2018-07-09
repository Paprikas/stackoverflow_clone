require "rails_helper"

describe "User sign in" do
  let(:user) { create(:user) }

  it "User can visit login page through root_path" do
    visit root_path
    click_on "Sign in"
  end

  it "Registered user trying to sign in" do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect(page).to have_content "Signed in successfully."
    expect(current_path).to eq root_path
  end

  it "Non-registered user trying to sign in" do
    visit new_user_session_path
    fill_in "Email", with: "yest12@example.com"
    fill_in "Password", with: "12345678"
    click_button "Log in"

    expect(page).to have_content "Invalid Email or password."
    expect(current_path).to eq new_user_session_path
  end
end
