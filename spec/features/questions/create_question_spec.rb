require 'rails_helper'

feature 'create question' do
  scenario 'Authenticated user creates question' do
    user = create(:user)
    sign_in(user)

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
