require 'rails_helper'

RSpec.describe AnswerPolicy do
  let(:guest) { nil }
  let(:user) { create(:user) }
  let(:admin) { create(:user, admin: true) }
  let(:answer) { create(:answer) }
  let(:user_answer) { create(:answer, user: user) }
  let(:user_question) { create(:question, user: user) }

  subject { described_class }

  permissions :create? do
    it { should_not permit(nil, Answer) }
    it { should permit(user, Answer) }
  end

  permissions :update?, :destroy? do
    it { should_not permit(guest, answer) }
    it { should_not permit(user, answer) }
    it { should permit(user, user_answer) }
    it { should permit(admin, answer) }
  end

  permissions :vote? do
    it { should_not permit(guest, answer) }
    it { should_not permit(user, user_answer) }
    it { should permit(user, answer) }
  end

  permissions :accept? do
    it { should_not permit(guest, answer) }
    it { should_not permit(user, answer) }
    it { should_not permit(user, user_answer) }
    it { should permit(user, create(:answer, question: user_question)) }
  end
end
