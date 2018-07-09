require "rails_helper"

RSpec.describe Subscription, type: :model do
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :question_id }

  # https://github.com/thoughtbot/shoulda-matchers/issues/682
  it do
    subject.user = build(:user)
    subject.question = build(:question)
    is_expected.to validate_uniqueness_of(:question_id).scoped_to(:user_id)
  end
end
