class Question < ApplicationRecord
  include Votable

  has_many :answers, -> { order(accepted: :desc) }, dependent: :destroy
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:file].blank? }, allow_destroy: true

  validates :title, :body, :user_id, presence: true
end
