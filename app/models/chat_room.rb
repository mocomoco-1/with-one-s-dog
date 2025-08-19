class ChatRoom < ApplicationRecord
  has_many :chat_room_users, dependent: :destroy
  has_many :users, through: :chat_room_users
  has_many :chat_messages, dependent: :destroy

  # roomの名前表示もし名前があればそれ、2人のuserでチャットするなら自分じゃない方のuserの名前を
  def display_name(current_user)
    if name.present?
      name
    elsif users.count == 2
      other_user = users.where.not(id: current_user.id).first
      other_user&.name || "Unknown User"
    else
      users.pluck(:name).join(", ")
    end
  end
end
