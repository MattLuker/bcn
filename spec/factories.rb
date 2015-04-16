FactoryGirl.define do
  factory :user do
    first_name 'Bob'
    last_name 'Slidell'
    sequence(:email) { |n| "user_#{n}@thehoick.com" }
    password 'beans'
  end
end