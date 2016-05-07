require 'rails_helper'

feature 'vote for question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  given(:votable) { question }
  given(:votable_selector) { "#question_#{question.id}" }

  it_behaves_like 'votes feature'
end
