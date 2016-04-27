require 'rails_helper'

feature 'answer on question' do
  let(:question) { create(:question) }

  scenario 'user can answer on question' do
    question
    visit root_path
    click_on question.title
    click_on 'Reply'
    fill_in 'Answer', with: 'Dunno'
    click_on 'Reply'
    expect(page).to have_content 'Dunno'
  end
end
