require 'rails_helper'

shared_examples 'views answer comment' do
  scenario 'views answer comment' do
    comment = create(:answer_comment, commentable: answer)
    visit question_path(answer.question)
    expect(page).to have_content comment.body
  end
end

feature 'create comments' do
  given(:user) { create(:user) }
  given(:answer) { create(:answer) }

  context 'as user', :js do
    background { sign_in user }

    it_behaves_like 'views answer comment'

    xscenario 'creates comment' do
      visit question_path(answer.question)
      within '.answer' do
        click_on 'add a comment'
        expect(page).not_to have_content 'add a comment'

        fill_in 'Comment', with: 'New comment'
        click_on 'Add Comment'
        within '.comments' do
          expect(page).to have_content 'New comment'
        end

        expect(page).not_to have_button 'Add Comment'
        expect(page).to have_content 'add a comment'
        expect(page).not_to have_selector('textarea')
        expect(find_field('Comment', visible: false).value).to be_empty
      end
    end

    scenario 'creates invalid comment' do
      visit question_path(answer.question)
      within '.answer' do
        click_on 'add a comment'
        click_on 'Add Comment'

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_button 'Add Comment'
        expect(page).not_to have_content 'add a comment'
        expect(page).to have_selector('textarea')
      end
    end
  end

  context 'as guest' do
    it_behaves_like 'views answer comment'

    scenario "can't create comment" do
      visit question_path(answer.question)
      expect(page).not_to have_content 'add a comment'
    end
  end
end
