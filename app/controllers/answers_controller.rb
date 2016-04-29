class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create, :update, :destroy]
  before_action :set_answer, :owner_check, only: [:update, :destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    respond_to do |format|
      if @answer.save
        format.html { redirect_to @question }
      else
        format.html { render 'questions/show' }
      end
      format.js
    end
  end

  def update
    render status: :unprocessable_entity unless @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def owner_check
    if @answer.user_id != current_user.id
      respond_to do |format|
        format.html { redirect_to @question }
        format.js { render body: nil, status: 401 }
      end
    end
  end
end
