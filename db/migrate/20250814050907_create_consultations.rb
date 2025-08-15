class CreateConsultations < ActiveRecord::Migration[7.2]
  def change
    create_table :consultations do |t|
      t.string :title, null:false
      t.text :content, null:false
      t.integer :reaction_category
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
