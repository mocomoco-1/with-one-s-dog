class ChatMessage < ApplicationRecord
  validates :content, presence: true

  belongs_to :user
  belongs_to :chat_room

  # メッセージ作成時に自動でブロードキャスト
  after_create_commit do
  Rails.logger.info "🔄 ChatMessage created - id=#{self.id}"
    if Rails.env.production?
      # 一時的に同期実行でテスト
      ChatMessageBroadcastJob.perform_now(self)
      Rails.logger.info "🚀 Job executed synchronously"
    else
      ChatMessageBroadcastJob.perform_later(self)
    end
  end
end
