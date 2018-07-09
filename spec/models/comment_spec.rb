require "rails_helper"

RSpec.describe Comment, type: :model do
  it { is_expected.to belong_to :commentable }
  it { is_expected.to belong_to :user }

  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :commentable_id }
  it { is_expected.to validate_presence_of :commentable_type }

  it_behaves_like "perform relay job after commit" do
    let(:job) { CommentRelayJob }
    let(:subject) { build(:answer_comment) }
  end
end
