class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :owner_check, only: [:update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = current_user.questions.new
    @question.attachments.build
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    render status: :unprocessable_entity unless @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to root_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def owner_check
    if @question.user_id != current_user.id
      respond_to do |format|
        format.html { redirect_to @question }
        format.js { render body: nil, status: 401 }
      end
    end
  end
end
