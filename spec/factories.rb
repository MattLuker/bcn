FactoryGirl.define do
  factory :user do
    first_name 'Bob'
    last_name 'Slidell'
    sequence(:email) { |n| "user_#{n}@thehoick.com" }
    password 'beans'
  end

  factory :post do
    title "New Posty Post"
    description "Posting things from the factory."
    user
  end
end