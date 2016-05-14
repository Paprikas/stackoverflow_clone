require 'rails_helper'

RSpec.describe OmniauthCallbacksControllerPolicy do
  let(:user) { User.new }
  subject { described_class }

  permissions :facebook?, :twitter? do
    it { should permit(nil, OmniauthCallbacksController) }
    it { should_not permit(user, OmniauthCallbacksController) }
  end
end
