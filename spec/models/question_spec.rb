require "rails_helper"

RSpec.describe Question, type: :model do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to have_many(:answers).dependent(:destroy).order(accepted: :desc, created_at: :asc) }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many(:attachments).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:attachments).allow_destroy(true) }
  it { is_expected.to have_many(:votes).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to have_many(:subscriptions).dependent(:destroy) }

  it_behaves_like "perform relay job after commit" do
    let(:job) { QuestionRelayJob }
    let(:subject) { build(:question) }
  end

  context "subscriptions" do
    let(:question) { build(:question) }

    it "receives subscribe_user after commit on create" do
      expect(question).to receive(:subscribe_user)
      question.save
    end

    it "creates subscription" do
      expect { question.save }.to change(Subscription, :count).by(1)
    end

    it "receives notify_user after update" do
      question.save
      expect(question).to receive(:notify_users).and_call_original
      expect(QuestionUpdateNotifyJob).to receive(:perform_later).with(question)
      question.update(body: "New body")
    end

    it "not receives notify_user after update if body is the same" do
      question.save
      expect(question).not_to receive(:notify_users)
      question.update(title: "New title")
    end
  end
end
