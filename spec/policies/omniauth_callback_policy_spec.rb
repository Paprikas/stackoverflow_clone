require 'rails_helper'

RSpec.describe OmniauthCallbackPolicy do
  let(:user) { User.new }
  subject { described_class }

  permissions :facebook?, :twitter? do
    it { should permit(nil, :omniauth_callback) }
    it { should_not permit(user, :omniauth_callback) }
  end
end
