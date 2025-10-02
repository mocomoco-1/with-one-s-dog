class AddLastReadMessageIdToChatRoomUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :chat_room_users, :last_read_message_id, :integer
  end
end
