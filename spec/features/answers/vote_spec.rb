require 'rails_helper'

shared_examples 'view answer vote score' do
  scenario 'can view answer vote score' do
    create(:answer_vote, votable: answer, score: 1)
    visit question_path(question)

    within "#answer_#{answer.id}" do
      expect(page).to have_content 'Score 1'
    end
  end
end

feature 'vote for answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  context 'authorized user' do
    background { sign_in user }

    context 'own answer' do
      scenario 'user can not vote for own answer' do
        user_answer = create(:answer, question: question, user: user)
        visit question_path(question)
        within "#answer_#{user_answer.id}" do
          expect(page).not_to have_content 'Vote up'
          expect(page).not_to have_content 'Vote down'
        end
      end
    end

    scenario 'user can vote' do
      visit question_path(question)

      within "#answer_#{answer.id}" do
        click_on 'Vote up'
        expect(page).to have_content 'Score 1'
        click_on 'Vote down'
        expect(page).to have_content 'Score -1'
      end
    end

    xscenario 'user can toggle vote' do
      visit question_path(question)

      within "#answer_#{answer.id}" do
        click_on 'Vote up'
        expect(page).to have_content 'Score 1'
        click_on 'Vote up'
        expect(page).to have_content 'Score 0'
      end
    end

    it_behaves_like 'view answer vote score'
  end

  context 'guest user' do
    it_behaves_like 'view answer vote score'

    scenario 'cannot participate in voting' do
      visit question_path(question)
      expect(page).not_to have_content 'Vote up'
      expect(page).not_to have_content 'Vote down'
    end
  end
end
