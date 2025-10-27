class ChatRoomUser < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  belongs_to :last_read_message, class_name: "ChatMessage", optional: true

  def unread_count
    Rails.logger.info "🔍 ChatRoomUser#unread_count start - user_id: #{user_id}, last_read_message_id: #{last_read_message_id}"
    # データの最新状態を取得
    chat_room.reload
    chat_room.chat_messages.reload
    if last_read_message_id.present?
      unread_messages = chat_room.chat_messages.where("id > ?", last_read_message_id).where.not(user_id: user_id)
    Rails.logger.info "🔍 Unread messages query: id > #{last_read_message_id}, excluding user_id: #{user_id}"
    Rails.logger.info "🔍 Found unread messages count: #{unread_messages.count}"
    unread_messages.count
    else
      all_messages = chat_room.chat_messages.where.not(user_id: user_id)
      Rails.logger.info "🔍 No last_read_message_id, counting all messages excluding user_id: #{user_id}"
      Rails.logger.info "🔍 All messages count: #{all_messages.count}"
      all_messages.count
    end
  end
end
