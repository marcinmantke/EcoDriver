FactoryGirl.define do
  factory :user do
    username    "Test_user"
    password    "12345678"
    email       "t@t.pl"
    car_type_id 1
  end
end
