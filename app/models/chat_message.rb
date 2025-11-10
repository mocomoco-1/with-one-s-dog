class ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many_attached :images
  after_create :notify_chat_room_users
  before_save :content_or_image_present

  after_create_commit do
    ChatMessageBroadcastJob.perform_later(self)
  end

  def read_by?(user)
    chat_room_user = chat_room.chat_room_users.find_by(user: user)
    return false unless chat_room_user&.last_read_message_id
    id <= chat_room_user.last_read_message_id
  end

  private

  def content_or_image_present
    if content.blank? && !images.attached?
      throw(:abort)
    end
  end

  def notify_chat_room_users
    recipients = chat_room.users.where.not(id: user.id)
    recipients.each do |recipient|
      NotificationService.create(sender: user, recipient: recipient, notifiable: self)
    end
  end
end
