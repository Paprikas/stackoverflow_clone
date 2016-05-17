class Api::V1::AnswersController < Api::V1::ApplicationController
  before_action :set_question, only: [:index, :create]

  def index
    respond_with @question.answers
  end

  def create
    authorize Answer
    @answer = @question.answers.create(answer_params.merge(user: current_user))
    respond_with @answer, location: @question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
