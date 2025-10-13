FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "tes#{n}" }
    sequence(:email) { |n| "tes#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    # LINE認証用（omniauthable対応）
    trait :with_line_auth do
      provider { 'line' }
      uid { SecureRandom.uuid }
    end
  end
end
