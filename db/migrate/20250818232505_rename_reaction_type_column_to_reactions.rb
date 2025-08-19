class RenameReactionTypeColumnToReactions < ActiveRecord::Migration[7.2]
  def change
    rename_column :reactions, :reaction_type, :reaction_category
  end
end
