require "rails_helper"

shared_examples "cannot delete answer or file" do
  it "cannot delete answer or file" do
    visit question_path(not_owned_answer.question)
    within ".answer#answer_#{not_owned_answer.id}" do
      expect(page).not_to have_link "Delete"
    end
    expect(page).not_to have_link "remove file"
  end
end

describe "delete answer" do
  let!(:user) { create(:user) }
  let!(:answer) { create(:answer, user: user) }
  let!(:not_owned_answer) { create(:answer) }
  let!(:question) { create(:question) }

  context "user access" do
    before { sign_in user }

    it "own answer", :js do
      visit question_path(answer.question)
      within ".answer#answer_#{answer.id}" do
        click_on "Delete"
      end
      expect(page).not_to have_css ".answer#answer_#{answer.id}"
    end

    # Disabled until ActionCable fix
    xit "create and delete answer", :js do
      visit question_path(question)
      fill_in "Answer", with: "Check ajax event reloaded"
      click_on "Submit answer"
      within ".answer" do
        click_on "Delete"
      end
      expect(page).not_to have_css ".answer"
    end

    xit "delete file", :js do
      create(:answer_attachment, attachable: answer)
      visit question_path(answer.question)
      expect(page).to have_link "spec_helper.rb"
      click_on "Edit"
      click_on "remove file"
      click_on "Update answer"
      expect(page).not_to have_link "spec_helper.rb"
    end

    describe "not own answer" do
      it_behaves_like "cannot delete answer or file"
    end
  end

  context "guest access" do
    it_behaves_like "cannot delete answer or file"
  end
end
