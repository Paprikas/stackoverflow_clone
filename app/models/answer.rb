class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:file].blank? }, allow_destroy: true

  has_many :votes, as: :votable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true

  def toggle_accept!
    transaction do
      toggle(:accepted)
      # TODO: move to scope
      question.answers.where(accepted: true).update_all(accepted: false) if accepted?
      save!
    end
  end

  def vote_up!(current_user)
    transaction do
      remove_vote!(current_user)
      votes.create!(user: current_user, score: '1')
    end
  end

  def vote_down!(current_user)
    transaction do
      remove_vote!(current_user)
      votes.create!(user: current_user, score: '-1')
    end
  end

  def remove_vote!(current_user)
    votes.where(user_id: current_user).destroy_all
  end
end
