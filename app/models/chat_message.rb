class ChatMessage < ApplicationRecord
  validates :content, presence: true

  belongs_to :user
  belongs_to :chat_room

  # メッセージ作成時に自動でブロードキャスト
  after_create_commit { ChatMessageBroadcastJob.perform_later(self) }
end
