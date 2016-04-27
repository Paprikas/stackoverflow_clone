require 'rails_helper'

feature 'view questions' do
  scenario 'user views questions' do
    create(:question, title: 'How much is the fish?')
    visit root_path
    expect(page).to have_content 'How much is the fish?'
  end
end
