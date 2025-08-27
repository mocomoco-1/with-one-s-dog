class Choice < ApplicationRecord
  belongs_to :question
  has_many :choices_diagnoses
  has_many :diagnoses, through: :choices_diagnoses

  validates :text, presence: true, length: { maximum: 255 }
end
