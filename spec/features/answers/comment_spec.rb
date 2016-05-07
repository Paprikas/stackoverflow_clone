require 'rails_helper'

feature 'comment question' do
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given(:commentable) { answer }
  given(:commentable_selector) { '.answer' }

  it_behaves_like 'comments feature'
end
