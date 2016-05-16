require 'rails_helper'

RSpec.describe QuestionPolicy do
  let(:guest) { nil }
  let(:user) { create(:user) }
  let(:admin) { create(:user, admin: true) }
  let(:question) { create(:question) }
  let(:user_question) { create(:question, user: user) }
  subject { described_class }

  permissions :show? do
    it { should permit(guest, question) }
  end

  permissions :create? do
    it { should_not permit(nil, question) }
    it { should permit(user, question) }
  end

  permissions :update?, :destroy? do
    it { should_not permit(guest, question) }
    it { should_not permit(user, question) }
    it { should permit(user, user_question) }
    it { should permit(admin, question) }
  end

  permissions :vote? do
    it { should_not permit(guest, question) }
    it { should_not permit(user, user_question) }
    it { should permit(user, question) }
  end
end
