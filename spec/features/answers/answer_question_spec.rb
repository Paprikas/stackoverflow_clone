require 'rails_helper'

feature 'answer on question' do
  scenario 'user can answer on question' do
    create(:question, title: 'How much is the fish?')

    visit root_path
    click_on 'How much is the fish?'
    click_on 'Reply'
    fill_in 'Answer', with: 'Dunno'
    click_on 'Reply'

    expect(page).to have_content 'Dunno'
  end
end
