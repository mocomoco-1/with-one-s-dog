class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    @chat_room = ChatRoom.find(params[:chat_room_id])
    stream_for @chat_room
    Rails.logger.info "🌷 ChatRoomChannel subscribed: room_id=#{params[:chat_room_id]}"
    Rails.logger.info "🌷 ChatRoomChannel subscribed: room_id=#{@chat_room.id} user=#{current_user.id}"
  end

  def unsubscribed
    Rails.logger.info "❌ ChatRoomChannel unsubscribed"
  end

  def mark_read(data)
    Rails.logger.info "🟨 ChatRoomChannel mark_read"

    chat_room_id = params[:chat_room_id] || data["chat_room_id"]
    return unless chat_room_id.present?

    new_id = (data["last_read_message_id"] || 0).to_i
    return if new_id.zero?

    chat_room = @chat_room || current_user.chat_rooms.find(chat_room_id)
    chat_room_user = chat_room.chat_room_users.find_by(user: current_user)

    chat_room_user.with_lock do
      current_last_id = chat_room_user.last_read_message_id || 0
      if new_id > current_last_id
        chat_room_user.update_column(:last_read_message_id, new_id)
        chat_room_user.reload
        Rails.logger.info "✅ 既読更新: user=#{current_user.id} #{current_last_id}→#{new_id}"
      else
        Rails.logger.info "🚫 巻き戻し無視: user=#{current_user.id} #{current_last_id}←#{new_id}"
      end
    end

    last_read_message = chat_room.chat_messages.find_by(id: new_id)
    if last_read_message
      reader_id = chat_room_user.user_id
      Rails.logger.info "🐾 before enqueue read job"
      ChatRoomChannel.broadcast_to(
        chat_room,
        {
          type: "read",
          reader_id: reader_id,
          last_read_message_id: last_read_message.id,
          chat_room_id: chat_room.id
        }
      )
      Rails.logger.info "🚀 after enqueue read job"
    else
      Rails.logger.warn "⚠️ last_read_message not found id=#{new_id}"
    end
    Rails.logger.info "📝 unread_count=#{chat_room_user.unread_count}"
  end
end
