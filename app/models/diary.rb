class Diary < ApplicationRecord
  validates :content, presence: true, length: { maximum: 65_535 }
  validates :written_on, presence: true, uniqueness: { scope: :user_id }
  belongs_to :user
  has_many :reactions, as: :reactable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many_attached :images

  enum status: { private: 0, published: 1 }, _prefix: true
end
