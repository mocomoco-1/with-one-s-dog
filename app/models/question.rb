class Question < ApplicationRecord
  has_many :choices

  validates :text, presence: true, length: { maximum: 255 }
end
