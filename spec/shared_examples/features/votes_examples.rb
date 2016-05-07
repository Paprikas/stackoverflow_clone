shared_examples 'votes feature' do
  context 'as user' do
    background do
      sign_in user
      visit question_path(question)
    end

    context 'as voter' do
      scenario 'can vote', :aggregate_failures do
        within votable_selector do
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
    end
  end

  context 'as votable author' do
    it_behaves_like "can't participate in voting" do
      background { sign_in votable.user }
    end
  end

  context 'as guest' do
    it_behaves_like "can't participate in voting"
    it_behaves_like 'view vote score'
  end
end

shared_examples "can't participate in voting" do
  scenario "can't see vote links", :aggregate_failures do
    visit question_path(question)
    within votable_selector do
      expect(page).not_to have_content 'Vote up'
      expect(page).not_to have_content 'Vote down'
    end
  end
end

shared_examples 'view vote score' do
  scenario 'can view vote score' do
    visit question_path(question)
    within votable_selector do
      expect(page).to have_content 'Score 0'
    end
  end
end
