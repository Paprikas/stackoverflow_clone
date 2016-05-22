class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  respond_to :json

  def create
    authorize Notification
    @notification = Notification.new(question: @question, user: current_user)
    @notification.save
    respond_with @notification, location: @question
  end

  def destroy
    @notification = Notification.find_by(user: current_user, question_id: @question)
    authorize @notification # Pundit::NotDefinedError: unable to find policy of nil???
    respond_with @notification.destroy, location: @question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
