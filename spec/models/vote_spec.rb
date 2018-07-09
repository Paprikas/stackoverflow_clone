require "rails_helper"

RSpec.describe Vote, type: :model do
  it { is_expected.to belong_to :votable }
  it { is_expected.to belong_to :user }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :votable_id }
  it { is_expected.to validate_presence_of :votable_type }
  it { is_expected.to validate_uniqueness_of(:votable_id).scoped_to(%i[votable_type user_id]) }
  it { is_expected.to validate_inclusion_of(:score).in_array([1, -1]) }
end
