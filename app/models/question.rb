class Question < ApplicationRecord
  has_many :answers, -> { order(accepted: :desc) }, dependent: :destroy
  has_many :attachments, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, presence: true
end
