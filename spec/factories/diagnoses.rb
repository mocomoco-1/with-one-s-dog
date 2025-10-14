FactoryBot.define do
  factory :diagnosis do
    sequence(:title) { |n| "診断結果#{n}" }
    sequence(:explanation) { |n| "診断結果#{n}の説明" }
    sequence(:dog_message) { |n| "一言#{n}" }
  end
end
