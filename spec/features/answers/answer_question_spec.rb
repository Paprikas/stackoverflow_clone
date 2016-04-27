require 'rails_helper'

feature 'answer on question' do
  given(:question) { create(:question) }
  given(:user) { create(:user) }
  background { question }

  scenario 'Authenticated user can answer on question with valid attributes' do
    sign_in(user)

    visit question_path(question)
    click_on 'Reply'
    fill_in 'Answer', with: 'Dunno'
    click_on 'Reply'
    expect(page).to have_content 'Dunno'
  end

  scenario 'Authenticated user cannot answer on question with invalid attributes' do
    sign_in(user)

    visit question_path(question)
    click_on 'Reply'
    click_on 'Reply'
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Guest user cannot answer on question' do
    visit root_path
    click_on question.title
    click_on 'Reply'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
