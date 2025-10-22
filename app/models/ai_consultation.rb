class AiConsultation < ApplicationRecord
  belongs_to :user
  has_many :ai_followups, dependent: :destroy
  validate :at_least_one_field_present

  def title
    if initial_response.present? && initial_response["summary"].present?
      initial_response["summary"].truncate(30)
    else
      "無題の相談"
    end
  end

  private

  def at_least_one_field_present
    if [ category, situation, dog_reaction, goal, details ].all?(&:blank?)
      errors.add(:base, "少なくとも1つの項目を入力してください")
    end
  end
end
