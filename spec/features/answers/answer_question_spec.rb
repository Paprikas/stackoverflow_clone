require 'rails_helper'

feature 'answer on question' do
  given(:question) { create(:question) }

  before { question }

  scenario 'Authenticated user can answer on question' do
    user = create(:user)

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    visit root_path
    click_on question.title
    click_on 'Reply'
    fill_in 'Answer', with: 'Dunno'
    click_on 'Reply'
    expect(page).to have_content 'Dunno'
  end

  scenario 'Guest user cannot answer on question' do
    visit root_path
    click_on question.title
    click_on 'Reply'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
