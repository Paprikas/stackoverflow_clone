require 'rails_helper'

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
      click_on 'Vote up'
      within "#answer_#{answer.id}" do
        expect(page).to have_content 'Score 1'
        expect(page).to have_content 'Remove vote'
      end

      click_on 'Vote down'
      within "#answer_#{answer.id}" do
        expect(page).to have_content 'Score -1'
        expect(page).to have_content 'Remove vote'
      end
    end

    scenario 'user can remove vote' do
      create(:answer_vote, votable: answer, user: user)
      visit question_path(question)
      click_on 'Remove vote'
      within "#answer_#{answer.id}" do
        expect(page).to have_content 'Score 0'
        expect(page).not_to have_content 'Remove vote'
      end
    end
  end

  scenario 'guest cannot participate in voting' do
    visit question_path(question)
    expect(page).not_to have_content 'Vote up'
    expect(page).not_to have_content 'Vote down'
    expect(page).not_to have_content 'Remove vote'
  end

  scenario 'can view vote score' do
    create(:answer_vote, votable: answer, score: 1)
    visit question_path(question)
    within "#answer_#{answer.id}" do
      expect(page).to have_content 'Score 1'
    end
  end
end