class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :likes, dependent: :destroy

  validates :content, presence: true, length: { maximum: 65_535 }
end
