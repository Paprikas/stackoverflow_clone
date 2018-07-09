require "rails_helper"

describe "subscriptions on question updates", :users do
  let(:question) { create(:question) }

  context "as user", :js, :auth do
    it "can subscribe" do
      visit question_path(question)
      click_on "Notify on updates for this question"
      expect(page).to have_content "Do not notify"
      expect(page).not_to have_content "Notify on updates for this question"
    end

    it "can unsubscribe" do
      create(:subscription, user: user, question: question)
      visit question_path(question)
      click_on "Do not notify"
      expect(page).not_to have_content "Do not notify"
      expect(page).to have_content "Notify on updates for this question"
    end
  end

  context "as question author", :js, :auth do
    let!(:question) { create(:question, user: user) }

    it "can unsubscribe" do
      visit question_path(question)
      click_on "Do not notify"
      expect(page).not_to have_content "Do not notify"
      expect(page).to have_content "Notify on updates for this question"
    end
  end

  context "as guest" do
    it "can not subscribe or unsubscribe" do
      visit question_path(question)
      expect(page).not_to have_content "Notify on updates for this question"
      expect(page).not_to have_content "Do not notify"
    end
  end
end
