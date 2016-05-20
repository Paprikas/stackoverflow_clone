shared_context "shared job", type: :job do
  ActiveJob::Base.queue_adapter = :test
end

shared_examples "enqueue job" do
  it "matches params with enqueued job" do
    expect {
      described_class.perform_later(record)
    }.to have_enqueued_job.with(record)
  end

  # TODO: Add arguments
  it 'broadcasts to ActionCable' do
    expect(ActionCable.server).to receive(:broadcast)
    described_class.perform_now(record)
  end
end
