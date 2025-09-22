class AiConsultation < ApplicationRecord
  belongs_to :user
  has_many :ai_followups, dependent: :destroy

  def title
    if initial_response.present? && initial_response["summary"].present?
      initial_response["summary"].truncate(30)
    else
      "無題の相談"
    end
  end
end
