class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:file].blank? }

  validates :body, :question_id, :user_id, presence: true

  def accept!
    transaction do
      toggle(:accepted)
      question.answers.where.not(id: self).update_all(accepted: false) if save! && accepted?
    end
  end
end
