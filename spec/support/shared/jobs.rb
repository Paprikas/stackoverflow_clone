shared_context "shared job", type: :job do
  ActiveJob::Base.queue_adapter = :test
  let(:hash) { {} }
end

shared_examples "enqueue job" do
  it "matches params with enqueued job" do
    expect {
      described_class.perform_later(record)
    }.to have_enqueued_job.with(record)
  end

  it 'broadcasts to ActionCable' do
    expect(ActionCable.server).to receive(:broadcast).with(channel, hash_including(hash))
    described_class.perform_now(record)
  end
end
