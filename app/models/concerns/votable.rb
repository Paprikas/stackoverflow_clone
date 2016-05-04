module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def toggle_vote_up!(current_user)
    toggle_vote(current_user, 'up')
  end

  def toggle_vote_down!(current_user)
    toggle_vote(current_user, 'down')
  end

  def vote_score
    votes.sum(:score)
  end

  private

  def toggle_vote(current_user, mode = 'up')
    @current_user = current_user

    transaction do
      if votes_exists?
        remove_vote!
      else
        create_vote(mode)
      end
    end
  end

  def remove_vote!
    votes.where(user_id: @current_user).destroy_all
  end

  def votes_exists?
    votes.where(user_id: @current_user).exists?
  end

  def create_vote(mode = 'up')
    score = mode == 'up' ? 1 : -1
    votes.create!(user: @current_user, score: score)
  end
end
