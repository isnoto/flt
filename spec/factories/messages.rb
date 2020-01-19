FactoryBot.define do
  factory :message do
    sequence(:email) { |n| "email#{n}@example.com" }
    sequence(:first_name) { |n| "First Name#{n}" }
    sequence(:last_name) { |n| "Last Name#{n}" }
    amount { rand(50) }
  end
end
