FactoryBot.define do
  factory :reaction do
    association :user
    reaction_category { :cheer }

    trait :for_consultation do
      association :reactable, factory: :consultation
    end
    trait :for_diary do
      association :reactable, factory: :diary
    end
  end
end
