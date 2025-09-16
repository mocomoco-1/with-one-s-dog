class ChatMessage < ApplicationRecord
  validates :content, presence: true

  belongs_to :user
  belongs_to :chat_room

  # メッセージ作成時に自動でブロードキャスト
  after_create_commit do
  Rails.logger.info "🔄 ChatMessage created - id=#{self.id}"
  ChatMessageBroadcastJob.perform_now(self)
    if image.attached?
      Rails.logger.info "📸 Image attached - processing in background"
      # 画像処理は非同期で実行
      ImageProcessingJob.perform_later(self)
    end
  end
end
