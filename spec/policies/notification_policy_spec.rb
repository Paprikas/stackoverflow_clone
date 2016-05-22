require 'rails_helper'

RSpec.describe NotificationPolicy do
  let(:record) { build_stubbed(:notification, user: user) }

  permissions :create? do
    let(:record) { Notification }

    it_grants_access
    it_behaves_like "access denied for guest"
  end

  permissions :destroy? do
    it_grants_access
    it_behaves_like "access denied for guest"
    it_behaves_like "access denied for non-author"
  end
end
