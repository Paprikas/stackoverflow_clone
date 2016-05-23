require 'rails_helper'

RSpec.describe SearchPolicy do
  permissions :search? do
    let(:record) { :search }
    it_behaves_like "access allowed for guest"
  end
end
