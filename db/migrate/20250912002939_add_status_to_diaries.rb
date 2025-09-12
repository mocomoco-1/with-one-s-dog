class AddStatusToDiaries < ActiveRecord::Migration[7.2]
  def change
    add_column :diaries, :status, :integer, null: false, default: 0
  end
end
