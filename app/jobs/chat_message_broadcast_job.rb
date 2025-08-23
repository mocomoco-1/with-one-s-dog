class ChatMessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(chat_message)
    rendered_message = render_message(chat_message)
    ChatRoomChannel.broadcast_to(
      chat_message.chat_room,
      message: rendered_message,
      sender_id: chat_message.user_id
    )
  end

  private

  # 特定のチャンネルにブロードキャスト
  def render_message(chat_message)
    ApplicationController.renderer.render(
      partial: "chat_messages/chat_message",
      locals: { chat_message: chat_message, current_user: chat_message.user }
    )
  end
end
