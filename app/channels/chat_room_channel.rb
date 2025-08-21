class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    chat_room = ChatRoom.find(params[:chat_room_id])
    stream_for chat_room
    Rails.logger.info "✅ ChatRoomChannel subscribed: room_id=#{params[:chat_room_id]}"
  end

  def unsubscribed
    Rails.logger.info "❌ ChatRoomChannel unsubscribed"
  end
end
