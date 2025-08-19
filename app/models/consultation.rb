class Consultation < ApplicationRecord
  acts_as_taggable_on :tags
  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 65_535 }

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy
end
