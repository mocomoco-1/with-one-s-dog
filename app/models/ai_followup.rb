class AiFollowup < ApplicationRecord
  belongs_to :ai_consultation

  validates :question, presence: true
  validates :response, presence: true
end
