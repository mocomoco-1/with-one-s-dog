class CreateInquiries < ActiveRecord::Migration[7.2]
  def change
    create_table :inquiries do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone_number
      t.text :message, null: false

      t.timestamps
    end
  end
end
