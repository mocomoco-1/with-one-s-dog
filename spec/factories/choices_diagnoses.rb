FactoryBot.define do
  factory :choices_diagnosis do
    association :choice
    association :diagnosis
  end
end
