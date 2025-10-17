FactoryBot.define do
  factory :notification do
    sender { association :user }
    recipient { association :user }
    association :notifiable, factory: :comment
    unread { true }
  end
end
