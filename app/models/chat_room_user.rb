class ChatRoomUser < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  belongs_to :last_read_message, class_name: "ChatMessage", optional: true

  def unread_count
    if last_read_message_id.present?
      chat_room.chat_messages.where("id > ?", last_read_message_id).where.not(user_id: user_id).count
    else
      chat_room.chat_messages.where.not(user_id: user_id).count
    end
  end
end
