module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable
    before_action :can_vote?, only: [:vote_up, :vote_down]
  end

  def vote_up
    @votable.toggle_vote_up!(current_user)
    render json: {id: @votable.id, score: @votable.vote_score}
  end

  def vote_down
    @votable.toggle_vote_down!(current_user)
    render json: {id: @votable.id, score: @votable.vote_score}
  end

  private

  def set_votable
    @votable = instance_variable_get("@#{controller_name.singularize}")
  end

  def can_vote?
    head :unprocessable_entity if @votable.user_id == current_user.id
  end
end
