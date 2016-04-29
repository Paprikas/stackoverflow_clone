require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should belong_to :question }
  it { should belong_to :user }

  describe 'toggle accepted' do
    it 'should toggle' do
      answer = create(:answer)
      expect {
        answer.accept!
      }.to change{answer.accepted}.from(false).to(true)
    end

    it 'should untoggle' do
      answer = create(:answer, accepted: true)
      expect {
        answer.accept!
      }.to change{answer.accepted}.from(true).to(false)
    end

    it 'should not toggle unless persisted' do
      answer = build(:answer)
      expect {
        answer.accept!
      }.not_to change{answer.accepted}
    end
  end

end
