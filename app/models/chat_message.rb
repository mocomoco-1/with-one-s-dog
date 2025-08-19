class ChatMessage < ApplicationRecord
  validates :content, presence: true

  belongs_to :user
  belongs_to :chat_room
end
