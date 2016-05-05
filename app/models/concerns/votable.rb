module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user, score)
    votes.create(user: user, score: score)
  end

  def cancel_vote(user)
    return false unless voted_by?(user)
    votes.where(user: user).destroy_all
    true
  end

  def vote_score
    votes.sum(:score)
  end

  private

  def voted_by?(user)
    votes.where(user: user).exists?
  end
end
