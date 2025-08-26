class ChoicesDiagnosis < ApplicationRecord
  belongs_to :choice
  belongs_to :diagnosis
  validates :choice_id, uniqueness: { scope: :result_id }
end
