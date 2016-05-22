require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should have_many(:answers).dependent(:destroy).order(accepted: :desc, created_at: :asc) }
  it { should belong_to :user }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments).allow_destroy(true) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it_behaves_like 'perform relay job after commit' do
    let(:job) { QuestionRelayJob }
    let(:subject) { build(:question) }
  end
end
