require 'rails_helper'

shared_examples 'cannot delete answer' do
  scenario 'cannot delete answer' do
    visit question_path(not_owned_answer.question)
    within ".answer#answer_#{not_owned_answer.id}" do
      expect(page).not_to have_link "Delete"
    end
  end
end

feature 'delete answer' do
  given!(:user) { create(:user) }
  given!(:answer) { create(:answer, user: user) }
  given!(:not_owned_answer) { create(:answer) }
  given!(:question) { create(:question) }

  context 'user access' do
    background { sign_in user }

    scenario 'own answer', js: true do
      visit question_path(answer.question)
      within ".answer#answer_#{answer.id}" do
        click_on 'Delete'
      end
      expect(page).not_to have_css ".answer#answer_#{answer.id}"
    end

    scenario 'create and delete answer', js: true do
      visit question_path(question)
      fill_in 'Answer', with: 'Check ajax event reloaded'
      click_on 'Submit answer'
      within ".answer" do
        click_on 'Delete'
      end
      expect(page).not_to have_css ".answer"
    end

    describe 'not own answer' do
      it_behaves_like 'cannot delete answer'
    end
  end

  context 'guest access' do
    it_behaves_like 'cannot delete answer'
  end
end
