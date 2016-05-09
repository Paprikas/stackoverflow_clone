class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create, :update, :destroy, :accept]
  before_action :set_answer, only: [:update, :destroy, :accept]
  before_action :owner_check, only: [:update, :destroy]

  include Voted

  respond_to :json
  respond_to :html, only: :accept

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    respond_with @answer do
      # ???
      return head :created, location: @question if @answer.save
    end
  end

  def update
    @answer.update(answer_params)
    respond_with @answer do
      # ???
      return render json: @answer, location: @question if @answer.valid?
    end
  end

  def destroy
    respond_with @answer.destroy
  end

  def accept
    @answer.toggle_accept!
    respond_with @answer, location: -> { question_path(@question) }
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
