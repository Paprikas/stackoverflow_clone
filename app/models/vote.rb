class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, :votable_id, :votable_type, presence: true
  validates :votable_id, uniqueness: { scope: [:votable_type, :user_id] }
  validates :score, inclusion: { in: [1, -1] }
  validate :votable_owner_cant_vote

  private

  def votable_owner_cant_vote
    return true if votable.user_id != user_id
    errors.add(:base, "user cannot vote for own #{votable.model_name.human}")
  end
end
