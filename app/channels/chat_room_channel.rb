class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    chat_room = ChatRoom.find(params[:chat_room_id])
    stream_for chat_room
    Rails.logger.info "🌷 ChatRoomChannel subscribed: room_id=#{params[:chat_room_id]}"
  end

  def unsubscribed
    Rails.logger.info "❌ ChatRoomChannel unsubscribed"
  end

  def mark_read(data)
    Rails.logger.info "🟨 ChatRoomChannel mark_read"
    room_id = data["id"]
    @chat_room = current_user.chat_rooms.find(room_id)
    chat_room_user = @chat_room.chat_room_users.find_by(user: current_user)
    new_id = data["last_read_message_id"].to_i
    current_last_id = chat_room_user.last_read_message_id || 0
    if new_id > current_last_id
      chat_room_user.update_column(:last_read_message_id, new_id)
    end
    last_read_message = @chat_room.chat_messages.find_by(id: new_id)
    if last_read_message
      ChatMessageReadBroadcastJob.perform_later(chat_room_user, last_read_message)
    else
      Rails.logger.warn "⚠️ last_read_message not found id=#{new_id}"
    end
  end
end
