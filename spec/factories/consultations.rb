FactoryBot.define do
  factory :consultation do
    title { "テストタイトル" }
    content { "テスト本文" }
    association :user
  end
end
