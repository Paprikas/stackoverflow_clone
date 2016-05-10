require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:identities).dependent(:destroy) }

  describe '.find_with_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user has identity' do
      it 'returns user' do
        user.identities.create(provider: 'facebook', uid: '123456')
        expect(described_class.find_with_oauth(auth)).to eq user
      end
    end

    context 'user has no identity' do
      context 'registered' do
        let(:auth) do
          OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email})
        end

        it 'does not create new user' do
          expect { described_class.find_with_oauth(auth) }.not_to change(described_class, :count)
        end

        it 'creates identity for user' do
          expect { described_class.find_with_oauth(auth) }.to change(user.identities, :count).by(1)
        end

        it 'creates identity with provider and uid', :aggregate_failures do
          identity = described_class.find_with_oauth(auth).identities.first

          expect(identity.provider).to eq auth.provider
          expect(identity.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(described_class.find_with_oauth(auth)).to eq user
        end
      end

      context 'not registered' do
        let(:auth) do
          OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@example.com'})
        end

        it 'creates user' do
          expect { described_class.find_with_oauth(auth) }.to change(described_class, :count).by(1)
        end

        it 'returns user with email', :aggregate_failures do
          user = described_class.find_with_oauth(auth)
          expect(user).to be_a described_class
          expect(user.email).to eq auth.info['email']
        end

        it 'creates identity for user', :aggregate_failures do
          identity = described_class.find_with_oauth(auth).identities.first
          expect(identity.provider).to eq auth.provider
          expect(identity.uid).to eq auth.uid
        end
      end
    end
  end
end
