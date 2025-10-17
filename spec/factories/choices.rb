FactoryBot.define do
  factory :choice do
    sequence(:text) { |n| "選択肢#{n}" }
    association :question
  end
end
