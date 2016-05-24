require 'rails_helper'

shared_examples 'searching' do |query, type|
  let(:model) do
    type == 'all' ? ThinkingSphinx : type.underscore.classify.constantize
  end

  it 'receives perform_search for Search' do
    expect(Search).to receive(:perform_search).with(query, type)
    Search.query(query, type)
  end
end

RSpec.describe Search, type: :model do
  context 'bad search type' do
    it 'not receives perform_search for Search' do
      expect(described_class).not_to receive(:perform_search).with('query', 'bad_type')
      described_class.query('query', 'bad_type')
    end

    it 'returns []' do
      expect(described_class.query('query', 'bad_type')).to eq []
    end
  end

  describe '.perform_search' do
    it 'receives escaped data', :aggregate_failures do
      query = 'need@escape.com'
      escaped = Riddle::Query.escape(query)
      expect(Riddle::Query).to receive(:escape).with(query).and_call_original
      expect(ThinkingSphinx).to receive(:search).with(escaped)
      described_class.perform_search(query, 'all')
    end
  end

  describe '.search' do
    it_behaves_like 'searching', 'query', 'all'
    it_behaves_like 'searching', 'query', 'question'
    it_behaves_like 'searching', 'query', 'answer'
    it_behaves_like 'searching', 'query', 'user'
  end
end
