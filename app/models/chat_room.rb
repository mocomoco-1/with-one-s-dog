class ChatRoom < ApplicationRecord
  has_many :chat_room_users, dependent: :destroy
  has_many :users, through: :chat_room_users
  has_many :chat_messages, dependent: :destroy

  # 指定した2人だけが参加している1対1チャットルームを探す
  scope :between, ->(user1_id, user2_id) {
    joins(:chat_room_users)
      .where(chat_room_users: { user_id: [ user1_id, user2_id ] })
      .group("chat_rooms.id")
      .having("COUNT(DISTINCT chat_room_users.user_id) = 2")
  }

  def display_name(user)
    other_user = users.where.not(id: user.id).first
    other_user&.name || "Unknown User"
  end

  def other_user(user)
    users.where.not(id: user.id).first
  end

  def latest_message
    chat_messages.order(created_at: :desc).first
  end

  def unread_count_for(user)
    chat_room_user = chat_room_users.find_by(user_id: user.id)
    chat_room_user&.unread_count.to_i
  end
end
