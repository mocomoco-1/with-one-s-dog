class ChatRoomUser < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  belongs_to :last_read_message, class_name: "ChatMessage", optional: true

  def unread_count
    latest_message_id = chat_room.chat_messages.maximum(:id)
    if last_read_message_id.present?
      if latest_message_id.nil? || last_read_message_id > latest_message_id
        Rails.logger.warn "⚠️ Inconsistent last_read_message_id detected. User: #{user_id}, last_read: #{last_read_message_id}, latest: #{latest_message_id}"
      return 0
      end
      chat_room.chat_messages.where("id > ?", last_read_message_id).where.not(user_id: user_id).count
    else
      chat_room.chat_messages.where.not(user_id: user_id).count
    end
  end
end
