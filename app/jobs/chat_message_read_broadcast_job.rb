class ChatMessageReadBroadcastJob < ApplicationJob
  queue_as :default

  def perform(chat_room_user, last_read_message)
    Rails.logger.info "🦴 ChatMessageReadBroadcastJob start user_id=#{chat_room_user.user_id} last_read=#{last_read_message.id}"
    chat_room = chat_room_user.chat_room
    reader_id = chat_room_user.user_id
    ChatRoomChannel.broadcast_to(
      chat_room,
      {
        type: "read",
        reader_id: chat_room_user.reader_id,
        last_read_message_id: last_read_message.id,
        chat_room_id: chat_room.id
      }
    )
    Rails.logger.info "📝 unread_count=#{chat_room_user.unread_count}"
    Rails.logger.info "🎈 ChatMessageReadBroadcastJob finished"
  end
end
