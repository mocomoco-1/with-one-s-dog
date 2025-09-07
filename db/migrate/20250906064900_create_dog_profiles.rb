class CreateDogProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :dog_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.date :comehome_date
      t.date :birthday
      t.boolean :birthday_unknown, default: false
      t.integer :age
      t.string :breed

      t.timestamps
    end
  end
end
