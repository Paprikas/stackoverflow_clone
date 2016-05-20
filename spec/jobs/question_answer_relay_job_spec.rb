require 'rails_helper'

RSpec.describe QuestionAnswerRelayJob, type: :job do
  let(:record) { create(:answer) }

  it_behaves_like 'enqueue job'
end
