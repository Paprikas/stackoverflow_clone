class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:file].blank? }, allow_destroy: true

  validates :body, :question_id, :user_id, presence: true

  # ???
  after_commit :question_answer_relay, on: :create

  def toggle_accept!
    transaction do
      toggle(:accepted)
      # TODO: move to scope
      question.answers.where(accepted: true).update_all(accepted: false) if accepted?
      save!
    end
  end

  private

  def question_answer_relay
    QuestionAnswerRelayJob.perform_later(self)
  end
end
