class QuestionAnswerRelayJob < ApplicationJob
  def perform(answer)
    ActionCable.server.broadcast "question:#{answer.question_id}:answers",
                                 answer: render_answer(answer)
  end

  private

  def render_answer(answer)
    # ActionView::Template::Error: undefined method `authenticate?' for nil:NilClass
    AnswersController.render(partial: 'answers/answer', locals: { answer: answer })
  end
end
