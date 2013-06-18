FactoryGirl.define do
  factory :user, :class => Cadenero::User do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "password"
  end
end 