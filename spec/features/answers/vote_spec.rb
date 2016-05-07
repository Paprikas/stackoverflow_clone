require 'rails_helper'

feature 'vote for answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  given(:votable) { answer }
  given(:votable_selector) { "#answer_#{answer.id}" }

  it_behaves_like 'votes feature'
end
