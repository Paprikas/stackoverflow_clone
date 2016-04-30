class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  def accept!
    return unless valid?
    toggle(:accepted)

    return unless persisted? && question.present?
    question.answers.update_all(accepted: false)
    save
  end
end
