class ChangeCommentsToPolymorphic < ActiveRecord::Migration[7.2]
  def up
    add_reference :comments, :commentable, polymorphic: true, index: true

    Comment.reset_column_information
    Comment.find_each do |comment|
    comment.update!(commentable_id: comment.consultation_id, commentable_type: "Consultation")
    end

    # consultation_id カラム削除
    remove_column :comments, :consultation_id, :bigint
  end

  def down
    add_column :comments, :consultation_id, :bigint
    remove_reference :comments, :commentable, polymorphic: true, index: true
  end
end
