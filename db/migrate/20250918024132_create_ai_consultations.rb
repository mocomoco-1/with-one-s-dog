class CreateAiConsultations < ActiveRecord::Migration[7.2]
  def change
    create_table :ai_consultations do |t|
      t.string :category
      t.string :situation
      t.text :dog_reaction
      t.text :goal
      t.text :details
      t.jsonb :initial_response
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
