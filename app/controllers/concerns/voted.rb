module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down]
    before_action :can_vote?, only: [:vote_up, :vote_down]
  end

  def vote_up
    @votable.vote(current_user, 1) unless @votable.cancel_vote(current_user)
    render json: {id: @votable.id, score: @votable.vote_score}
  end

  def vote_down
    @votable.vote(current_user, -1) unless @votable.cancel_vote(current_user)
    render json: {id: @votable.id, score: @votable.vote_score}
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def can_vote?
    head :unprocessable_entity if @votable.user_id == current_user.id
  end
end
