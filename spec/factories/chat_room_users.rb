FactoryBot.define do
  factory :chat_room_user do
    association :user
    association :chat_room
    last_read_message_id { nil }
  end
end
