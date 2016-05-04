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

  def setup(args)
    user, mode = args
    @current_user = user
    @score = mode == 'up' ? 1 : -1
    @score_to_remove = mode == 'up' ? -1 : 1
  end

  def toggle_vote(*args)
    setup(args)
    remove_vote!(@score_to_remove)

    transaction do
      if votes_exists?
        remove_vote!(@score)
      else
        create_vote
      end
    end
  end

  def remove_vote!(score)
    votes.where(user_id: @current_user, score: score).destroy_all
  end

  def votes_exists?
    votes.where(user_id: @current_user, score: @score).exists?
  end

  def create_vote
    votes.create!(user: @current_user, score: @score)
  end
end
