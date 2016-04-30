class Question < ApplicationRecord
  has_many :answers, -> { order(accepted: :desc) }, dependent: :destroy
  has_many :attachments, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:file].blank? }

  validates :title, :body, :user_id, presence: true
end
