require 'rails_helper'

feature 'answer on question' do
  given(:question) { create(:question) }
  background { question }

  scenario 'Authenticated user can answer on question' do
    user = create(:user)
    sign_in(user)

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
