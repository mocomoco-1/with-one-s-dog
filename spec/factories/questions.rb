FactoryBot.define do
  factory :question do
    sequence(:text) { |n| "質問#{n}の内容" }
  end
end
