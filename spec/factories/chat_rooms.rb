FactoryBot.define do
  factory :chat_room do
    trait :with_users do
      transient do
        users_count { 2 }
      end

      after(:create) do |chat_room, evaluator|
        users = create_list(:user, evaluator.users_count)
        users.each do |user|
          chat_room.chat_room_users.create!(user: user) # 中間テーブル作成
        end
      end
    end
  end
end
