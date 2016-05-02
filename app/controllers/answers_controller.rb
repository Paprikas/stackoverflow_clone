class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create, :update, :destroy, :accept, :vote]
  before_action :set_answer, only: [:update, :destroy, :accept, :vote]
  before_action :owner_check, only: [:update, :destroy]

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

  def accept
    @answer.toggle_accept!
    redirect_to @question
  end

  def vote
    return redirect_to @question if @answer.user_id == current_user.id # remove when refactored with xhr
    if params[:mode] == 'up'
      @answer.vote_up!(current_user)
    elsif params[:mode] == 'down'
      @answer.vote_down!(current_user)
    else
      @answer.remove_vote!(current_user)
    end
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
    render body: nil, status: 401 if @answer.user_id != current_user.id
  end
end
