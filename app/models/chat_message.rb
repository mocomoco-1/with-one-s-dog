class ChatMessage < ApplicationRecord
  validates :content, presence: true

  belongs_to :user
  belongs_to :chat_room
  has_many :notifications, as: :notifiable, dependent: :destroy

  # メッセージ作成時に自動でブロードキャスト
  after_create_commit do
  # Rails.logger.info "🔄 ChatMessage created - id=#{self.id}"
  ChatMessageBroadcastJob.perform_now(self)
    # if image.attached?
    #   Rails.logger.info "📸 Image attached - processing in background"
    #   # 画像処理は非同期で実行
    #   ImageProcessingJob.perform_later(self)
    # end
  end

  private

  def create_notification
    recipient = chat_room_users.where.not(id: user.id).first
    return unless recipient

    Notification.create!(
      sender: user,
      recipient: recipient,
      notifiable: self
    )
  end
end
