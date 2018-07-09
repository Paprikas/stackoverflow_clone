require "rails_helper"

describe "accept answer" do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:not_own_question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  context "authorized user" do
    before { sign_in user }

    context "own question" do
      it "user can accept answer" do
        visit question_path(question)
        click_on "Accept answer"
        expect(page).to have_content "Accepted answer"
      end

      it "user can undo accept answer" do
        answer = create(:answer, question: question, accepted: true)
        visit question_path(answer.question)
        click_on "Do not accept this answer"
        expect(page).not_to have_content "Do not accept this answer"
        expect(page).to have_content "Accept answer"
      end

      it "user can accept another answer", :js do # not work with rack_test
        accepted_answer = create(:answer, question: question, accepted: true)
        visit question_path(question)

        within "#answer_#{accepted_answer.id}" do
          expect(page).to have_content "Accepted answer"
          expect(page).not_to have_content "Accept answer"
        end

        within "#answer_#{answer.id}" do
          click_on "Accept answer"
          expect(page).to have_content "Accepted answer"
        end

        within "#answer_#{accepted_answer.id}" do
          expect(page).not_to have_content "Accepted answer"
          expect(page).to have_content "Accept answer"
        end
      end

      it "accepted answer first list" do
        create(:answer, question: question, accepted: true)
        visit question_path(question)
        within ".answer:first-child" do
          expect(page).to have_content "Accepted answer"
        end
      end
    end

    it "user cannot accept answer of not own question" do
      answer = create(:answer)
      visit question_path(answer.question)
      expect(page).not_to have_content "Accept answer"
    end
  end

  it "guest cannot accept answer" do
    visit question_path(question)
    expect(page).not_to have_content "Accept answer"
  end

  it "guest can see accepted answer" do
    answer = create(:answer, accepted: true)
    visit question_path(answer.question)
    expect(page).to have_content "Accepted answer"
  end
end
