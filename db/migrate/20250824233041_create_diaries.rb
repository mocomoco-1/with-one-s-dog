class CreateDiaries < ActiveRecord::Migration[7.2]
  def change
    create_table :diaries do |t|
      t.date :written_on, null: false
      t.text :content, null: false
      t.string :image
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :diaries, [ :written_on, :user_id ], unique: true
  end
end
