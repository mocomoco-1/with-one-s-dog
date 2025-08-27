class CreateDiagnoses < ActiveRecord::Migration[7.2]
  def change
    create_table :diagnoses do |t|
      t.string :title, null: false
      t.text :explanation, null: false
      t.text :dog_message, null: false

      t.timestamps
    end
  end
end
