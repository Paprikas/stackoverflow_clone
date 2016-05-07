class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create, :update, :destroy, :accept]
  before_action :set_answer, only: [:update, :destroy, :accept]
  before_action :owner_check, only: [:update, :destroy]

  include Voted
  include Commented

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      head :created, location: @question
    else
      render json: {errors: @answer.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    render status: :unprocessable_entity unless @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  def accept
    @answer.toggle_accept!
    redirect_to @question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def owner_check
    head :forbidden if @answer.user_id != current_user.id
  end
end
