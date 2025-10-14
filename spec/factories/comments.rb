FactoryBot.define do
  factory :comment do
    content { "テストコメント" }
    association :user
    association :commentable, factory: :diary
  end
end
