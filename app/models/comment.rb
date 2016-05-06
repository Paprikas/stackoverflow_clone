class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :user_id, :body, :commentable_id, :commentable_type, presence: true
end
