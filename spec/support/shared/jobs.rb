shared_context "shared job", type: :job do
  # around do |example|
  #   active_job_queue_adapter = ActiveJob::Base.queue_adapter
  #   ActiveJob::Base.queue_adapter = :test
  #   example.run
  #   ActiveJob::Base.queue_adapter = active_job_queue_adapter
  # end

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
