module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: :comment
  end

  def comment
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      render json: {
        commentable: @commentable.class.name.underscore,
        commentable_id: @commentable.id
      }
    else
      render json: {errors: @comment.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end
end
