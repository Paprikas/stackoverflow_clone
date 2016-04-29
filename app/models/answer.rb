class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  def accept!
    toggle(:accepted)

    if persisted? && question.present?
      question.answers.update_all(accepted: false)
      save
    end
  end
end
