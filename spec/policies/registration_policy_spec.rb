require 'rails_helper'

RSpec.describe RegistrationPolicy do
  let(:user) { User.new }
  subject { described_class }

  permissions :finish_signup?, :send_confirmation_email? do
    # it { should permit(nil, RegistrationsController) } ???
    # it { should_not permit(user, RegistrationsController) }
  end
end
