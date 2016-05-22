require 'rails_helper'

RSpec.describe QuestionAnswerNotificationJob, type: :job do
  let!(:answer) { create(:answer) }

  it 'schedule emails for subscribed users on question', :users do
    expect(QuestionMailer).to receive(:new_answer)
    # expect(QuestionMailer.new_answer).to receive(:perform_now)
    described_class.perform_now(answer)
  end
end
