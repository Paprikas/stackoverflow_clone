require 'rails_helper'

feature 'comment question' do
  given(:question) { create(:question) }
  given(:commentable) { question }
  given(:commentable_selector) { '.question' }

  it_behaves_like 'comments feature'
end
