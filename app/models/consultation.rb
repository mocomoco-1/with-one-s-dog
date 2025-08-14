class Consultation < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validated :content, presence: ture, length: { maximum: 65_535 }

  belongs_to :user
end
