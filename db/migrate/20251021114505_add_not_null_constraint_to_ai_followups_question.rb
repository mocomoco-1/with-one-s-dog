class AddNotNullConstraintToAiFollowupsQuestion < ActiveRecord::Migration[7.2]
  def change
    change_column_null :ai_followups, :question, false
  end
end
