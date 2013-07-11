FactoryGirl.define do
  factory :user, :class => Cadenero::User do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "password"
    password_confirmation "password"
  end
end 