class ChatRoom < ApplicationRecord
  has_many :chat_room_users, dependent: :destroy
  has_many :users, through: :chat_room_users
  has_many :chat_messages, dependent: :destroy
  # 指定した2人だけが参加している1対1チャットルームを探す
  scope :between, ->(user1_id, user2_id) {
    joins(:chat_room_users)
    .group("chat_rooms.id")
    .having("ARRAY_AGG(chat_room_users.user_id) @> ARRAY[?]::bigint[] AND ARRAY_AGG(chat_room_users.user_id) @> ARRAY[?]::bigint[]", user1_id, user2_id)
    }
  # roomの名前表示もし名前があればそれ、2人のuserでチャットするなら自分じゃない方のuserの名前を
  def display_name(user)
    if users.count == 2
      other_user = users.where.not(id: user.id).first
      other_user&.name || "Unknown User"
    else
      users.pluck(:name).join(", ")
    end
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
