class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :owner_check, only: [:update, :destroy]
  before_action :build_answer, only: :show

  include Voted

  respond_to :html, except: :update

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = current_user.questions.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    render status: :unprocessable_entity unless @question.update(question_params)
  end

  def destroy
    respond_with @question.destroy, location: root_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def owner_check
    if @question.user_id != current_user.id
      respond_to do |format|
        format.html { redirect_to @question }
        format.js { head :forbidden }
      end
    end
  end

  def build_answer
    @answer = @question.answers.build
  end
end
