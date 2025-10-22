class AddCheckConstraintToAiConsultations < ActiveRecord::Migration[7.2]
  def change
    add_check_constraint :ai_consultations,
    "COALESCE(NULLIF(category, ''), NULLIF(situation, ''), NULLIF(dog_reaction, ''), NULLIF(goal, ''), NULLIF(details, '')) IS NOT NULL",
    name: "ai_consultations_at_least_one_field_present"
  end
end
