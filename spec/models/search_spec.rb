require 'rails_helper'

shared_examples 'searching' do |query, type|
  let(:model) do
    type == 'all' ? ThinkingSphinx : type.underscore.classify.constantize
  end

  it "receives search for #{type}" do
    expect(model).to receive(:search).with(query)
    Search.query(query, type)
  end

  it 'receives perform_search for Search' do
    expect(Search).to receive(:perform_search).with(query, type)
    Search.query(query, type)
  end
end

RSpec.describe Search, type: :model do
  it_behaves_like 'searching', 'query', 'all'
  it_behaves_like 'searching', 'query', 'question'
  it_behaves_like 'searching', 'query', 'answer'
  it_behaves_like 'searching', 'query', 'user'

  context 'bad search type' do
    it 'not receives perform_search for Search' do
      expect(described_class).not_to receive(:perform_search).with('query', 'bad_type')
      described_class.query('query', 'bad_type')
    end

    it 'returns []' do
      expect(described_class.query('query', 'bad_type')).to eq []
    end
  end
end
