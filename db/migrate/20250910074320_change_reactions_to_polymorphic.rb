class ChangeReactionsToPolymorphic < ActiveRecord::Migration[7.2]
  def up
    add_reference :reactions, :reactable, polymorphic: true, index: true

    Reaction.reset_column_information
    Reaction.find_each do |reaction|
      reaction.update!(reactable_id: reaction.consultation_id, reactable_type: "Consultation")
    end
    remove_column :reactions, :consultation_id, :bigint
  end

  def down
    add_column :reactions, consultation_id, :bigint
    remove_reference :reactions, :reactable, polymorphic: true, index: true
  end
end
