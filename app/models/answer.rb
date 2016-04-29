class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  def accept!
    return unless persisted?
    question.answers.update_all(accepted: false)
    toggle!(:accepted)
  end
end
