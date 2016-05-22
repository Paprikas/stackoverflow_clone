class QuestionDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    questions = Question.where(created_at: 1.day.ago..Time.current)
    return unless questions.present?
    User.find_each do |user|
      QuestionMailer.digest(user, questions).deliver_later
    end
  end
end
