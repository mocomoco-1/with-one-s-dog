class CreateAiFollowups < ActiveRecord::Migration[7.2]
  def change
    create_table :ai_followups do |t|
      t.text :question
      t.text :response
      t.references :ai_consultation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
