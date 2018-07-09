class QuestionDigestJob < ApplicationJob
  queue_as :default

  def perform
    questions = Question.where(created_at: Time.current.yesterday.all_day)
    return if questions.blank?
    User.find_each do |user|
      QuestionMailer.digest(user, questions).deliver_later
    end
  end
end
