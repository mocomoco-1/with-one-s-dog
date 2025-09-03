class AddUniqueIndexToUsersName < ActiveRecord::Migration[7.2]
  def change
    remove_index :users, :name
    add_index :users, :name, unique: true
  end
end
