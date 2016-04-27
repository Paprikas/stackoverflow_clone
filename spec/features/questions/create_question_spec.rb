require 'rails_helper'

feature 'create question' do
  scenario 'Authenticated user creates question' do
    user = create(:user)

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    click_on 'Ask Question'
    fill_in 'Title', with: 'How much is the fish?'
    fill_in 'Body', with: "Can't find price"
    click_on 'Create question'

    expect(page).to have_content 'How much is the fish?'
    expect(page).to have_content "Can't find price"
  end

  scenario 'guest creates question' do
    visit root_path
    click_on 'Ask Question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
