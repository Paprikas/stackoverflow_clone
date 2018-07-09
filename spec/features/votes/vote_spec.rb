require "rails_helper"

shared_examples "votes feature" do
  context "as user" do
    before do
      sign_in user
      visit question_path(question)
    end

    context "as voter" do
      it "can vote", :aggregate_failures, :js do
        within votable_selector do
          expect(page).to have_content "Score 0"
          expect(page).to have_content "Vote up"
          expect(page).to have_content "Vote down"
          click_on "Vote up"
          expect(page).to have_content "Score 1"
          expect(page).not_to have_content "Vote up"
          expect(page).not_to have_content "Vote down"
          click_on "Remove vote"
          expect(page).to have_content "Score 0"
          expect(page).to have_content "Vote up"
          expect(page).to have_content "Vote down"
          click_on "Vote down"
          expect(page).to have_content "Score -1"
          expect(page).not_to have_content "Vote up"
          expect(page).not_to have_content "Vote down"
        end
      end
    end
  end

  context "as votable author" do
    it_behaves_like "can't participate in voting" do
      before { sign_in votable.user }
    end
  end

  context "as guest" do
    it_behaves_like "can't participate in voting"
    it_behaves_like "view vote score"
  end
end

shared_examples "can't participate in voting" do
  it "can't see vote links", :aggregate_failures do
    visit question_path(question)
    within votable_selector do
      expect(page).not_to have_content "Vote up"
      expect(page).not_to have_content "Vote down"
    end
  end
end

shared_examples "view vote score" do
  it "can view vote score" do
    visit question_path(question)
    within votable_selector do
      expect(page).to have_content "Score 0"
    end
  end
end

describe "vote for answer" do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  let(:votable) { answer }
  let(:votable_selector) { "#answer_#{answer.id}" }

  it_behaves_like "votes feature"
end

describe "vote for question" do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  let(:votable) { question }
  let(:votable_selector) { "#question_#{question.id}" }

  it_behaves_like "votes feature"
end
