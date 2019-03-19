FactoryGirl.define do
  factory :user do
    email 'brent@example.com'
    password 'abcd1234'
    password_confirmation 'abcd1234'
  end
end
