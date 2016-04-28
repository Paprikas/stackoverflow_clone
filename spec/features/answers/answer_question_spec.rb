require 'rails_helper'

feature 'answer on question' do
  given(:question) { create(:question) }
  given(:user) { create(:user) }
  background { question }

  scenario 'Authenticated user can answer on question with valid attributes', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Answer', with: 'Dunno'
    click_on 'Submit answer'
    within '.answers' do
      expect(page).to have_content 'Dunno'
    end
    expect(find_field('Answer').value).to be_empty
  end

  scenario 'Authenticated user cannot answer on question with invalid attributes', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Submit answer'
    within '#answer_errors' do
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Guest user cannot answer on question' do
    visit root_path
    click_on question.title
    expect(page).to have_content 'Please sign in to answer the question.'
  end
end
