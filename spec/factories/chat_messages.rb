FactoryBot.define do
  factory :chat_message do
    association :user
    association :chat_room
    sequence(:content) { |n| "メッセージ#{n}" }
  end
end
