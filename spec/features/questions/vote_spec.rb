require 'rails_helper'

shared_examples 'view question vote score' do
  scenario 'can view question vote score' do
    create(:question_vote, votable: question, score: 1)
    visit question_path(question)

    within "#question_#{question.id}" do
      expect(page).to have_content 'Score 1'
    end
  end
end

feature 'vote for question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'authorized user' do
    background { sign_in user }

    context 'own question' do
      scenario 'user can not vote for own question' do
        user_question = create(:question, user: user)
        visit question_path(user_question)
        within "#votable_question_#{user_question.id}" do
          expect(page).not_to have_content 'Vote up'
          expect(page).not_to have_content 'Vote down'
        end
      end
    end

    scenario 'user can vote' do
      visit question_path(question)

      within "#question_#{question.id}" do
        expect(page).to have_content 'Score 0'
        expect(page).to have_content 'Vote up'
        expect(page).to have_content 'Vote down'
        click_on 'Vote up'
        expect(page).to have_content 'Score 1'
        expect(page).not_to have_content 'Vote up'
        expect(page).not_to have_content 'Vote down'
        click_on 'Remove vote'
        expect(page).to have_content 'Score 0'
        expect(page).to have_content 'Vote up'
        expect(page).to have_content 'Vote down'
        click_on 'Vote down'
        expect(page).to have_content 'Score -1'
        expect(page).not_to have_content 'Vote up'
        expect(page).not_to have_content 'Vote down'
      end
    end

    it_behaves_like 'view question vote score'
  end

  context 'guest user' do
    it_behaves_like 'view question vote score'

    scenario 'cannot participate in voting' do
      visit question_path(question)
      expect(page).not_to have_content 'Vote up'
      expect(page).not_to have_content 'Vote down'
    end
  end
end
