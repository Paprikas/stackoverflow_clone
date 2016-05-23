require 'rails_helper'

feature 'search and view results' do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer) }
  given!(:comment) { create(:answer_comment) }
  given!(:user) { create(:user) }

  background { visit root_path }

  xscenario 'all', :sphinx_index do
    click_on 'Search'
    expect(page).to have_content question.title
    expect(page).to have_content answer.body
    expect(page).to have_content comment.body
    expect(page).to have_content user.email
  end

  xscenario 'questions', :sphinx_index do
    fill_in 'search_query', with: question.title
    select 'question', from: 'search_type'
    click_on 'Search'
    expect(page).to have_content question.title
    expect(page).not_to have_content answer.body
    expect(page).not_to have_content comment.body
    expect(page).not_to have_content user.email
  end

  scenario 'answers'
  scenario 'comments'
end
