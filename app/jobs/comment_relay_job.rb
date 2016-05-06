class CommentRelayJob < ApplicationJob
  def perform(comment)
    ActionCable.server.broadcast "question:#{comment.commentable_id}:comments",
                                 comment: render_comment(comment),
                                 commentable: comment.commentable_type.underscore,
                                 commentable_id: comment.commentable_id
  end

  private

  def render_comment(comment)
    CommentsController.render(partial: 'comments/comment', locals: { comment: comment })
  end
end
