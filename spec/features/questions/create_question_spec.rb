require 'rails_helper'

feature 'create question' do
  scenario 'user creates question' do
    visit root_path
    click_on 'Ask Question'
    fill_in 'Title', with: 'How much is the fish?'
    fill_in 'Body', with: "Can't find price"
    click_on 'Create question'

    expect(page).to have_content 'How much is the fish?'
    expect(page).to have_content "Can't find price"
  end
end
