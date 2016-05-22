class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, -> { order(accepted: :desc, created_at: :asc) }, dependent: :destroy
  has_many :notifications, dependent: :destroy
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:file].blank? }, allow_destroy: true

  validates :title, :body, :user_id, presence: true

  after_commit { QuestionRelayJob.perform_later(self) }
  after_create :subscribe_user

  private

  # test in controller???
  def subscribe_user
    Notification.create(user_id: user_id, question: self)
  end
end
