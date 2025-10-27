class ChatMessageBroadcastJob < ApplicationJob
  queue_as :default
  # 新しいメッセージをリアタイで配信するためのjob
  def perform(chat_message)
    Rails.logger.info "🚀 ChatMessageBroadcastJob perform start - chat_message_id=#{chat_message.id}"
    rendered_message = render_message(chat_message)
    ChatRoomChannel.broadcast_to(
      chat_message.chat_room,
      type: "message",
      message: rendered_message,
      sender_id: chat_message.user_id
    )
    chat_message.chat_room.users.each do |user|
      next if user.id == chat_message.user_id
      # ここでデバッグ情報を追加
      chat_room_user = chat_message.chat_room.chat_room_users.find_by(user: user)
      unread_count = chat_message.chat_room.unread_count_for(user)
      Rails.logger.info "🔍 User #{user.id}: last_read_message_id=#{chat_room_user&.last_read_message_id}, latest_message_id=#{chat_message.id}, unread_count=#{unread_count}"
      # kokomade
      RoomsListChannel.broadcast_to(
        user,
        {
          room_id: chat_message.chat_room.id,
          has_images: chat_message.images.attached?,
          last_message: chat_message.content.truncate(20),
          unread_count: chat_message.chat_room.unread_count_for(user),
          latest_time: I18n.l(chat_message.created_at, format: :short)
        }
      )
    end
    Rails.logger.info "✅ ChatMessageBroadcastJob perform finished - chat_message_id=#{chat_message.id}"
  end

  private

  # 特定のチャンネルにブロードキャスト
  def render_message(chat_message)
    ApplicationController.renderer.render(
      partial: "chat_messages/chat_message",
      locals: { chat_message: chat_message }
    )
  end
end
