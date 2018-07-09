require "rails_helper"

RSpec.describe Identity, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :uid }
  it { is_expected.to validate_presence_of :provider }
  it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider) }

  describe ".find_for_oauth" do
    let!(:identity) { create(:identity, uid: 123) }
    let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: 123) }

    it "returns identity" do
      expect(described_class.find_for_oauth(auth)).to eq identity
    end
  end
end
