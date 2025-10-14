FactoryBot.define do
  factory :dog_profile do
    association :user
    name { "ともに" }
    birthday { Date.new(2020, 6, 6) }
    comehome_date { Date.new(2021, 10, 15) }
    age { nil }
  end
end
