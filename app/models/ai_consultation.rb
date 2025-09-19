class AiConsultation < ApplicationRecord
  belongs_to :user
  has_many :ai_followups, dependent: :destroy
end
