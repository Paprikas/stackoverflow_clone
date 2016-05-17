require 'rails_helper'

RSpec.describe ProfilesPolicy do
  let(:guest) { nil }
  let(:user) { create(:user) }

  subject { described_class }

  permissions :me?, :all? do
    it { should_not permit(nil, :profiles) }
    it { should permit(user, :profiles) }
  end
end
