class ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many_attached :images
  after_create :notify_chat_room_users
  validate :content_or_image_present
  # メッセージ作成時に自動でブロードキャスト
  after_create_commit do
  # Rails.logger.info "🔄 ChatMessage created - id=#{self.id}"
  ChatMessageBroadcastJob.perform_later(self)
    # if image.attached?
    #   Rails.logger.info "📸 Image attached - processing in background"
    #   # 画像処理は非同期で実行
    #   ImageProcessingJob.perform_later(self)
    # end
  end

  def read_by?(user)
    chat_room_user = chat_room.chat_room_users.find_by(user: user)
    return false unless chat_room_user&.last_read_message_id
    id <= chat_room_user.last_read_message_id
  end

  private

  def content_or_image_present
    if content.blank? && images.blank?
      errors.add(:base, "メッセージまたは画像を入力してください")
    end
  end

  def notify_chat_room_users
    recipients = chat_room.users.where.not(id: user.id)
    recipients.each do |recipient|
      NotificationService.create(sender: user, recipient: recipient, notifiable: self)
    end
  end
end
