FactoryBot.define do
  factory :like do
    association :user
    association :comment
  end
end
