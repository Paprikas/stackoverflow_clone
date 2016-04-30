class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  def accept!
    transaction do
      toggle(:accepted)
      question.answers.where.not(id: self).update_all(accepted: false) if save! && accepted?
    end
  end
end
