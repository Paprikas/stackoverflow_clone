class QuestionAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    question = answer.question
    Notification.includes(:user).where(question_id: question.id).where.not(user_id: answer.user_id).find_each do |notification|
      QuestionMailer.new_answer(notification.user, question, answer).deliver_later
    end
  end
end
