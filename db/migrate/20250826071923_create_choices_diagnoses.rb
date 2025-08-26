class CreateChoicesDiagnoses < ActiveRecord::Migration[7.2]
  def change
    create_table :choices_diagnoses do |t|
      t.references :choice, null: false, foreign_key: true
      t.references :diagnosis, null: false, foreign_key: true

      t.timestamps
    end
  end
end
