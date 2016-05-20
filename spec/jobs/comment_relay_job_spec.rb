require 'rails_helper'

RSpec.describe CommentRelayJob, type: :job do
  context 'question' do
    let(:record) { create(:question_comment) }
    it_behaves_like 'enqueue job'
  end

  context 'answer' do
    let(:record) { create(:answer_comment) }

    it_behaves_like 'enqueue job'
  end
end
