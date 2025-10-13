FactoryBot.define do
  factory :diary do
    written_on { Date.today }
    content { "これはテストです" }
    association :user
  end
end
