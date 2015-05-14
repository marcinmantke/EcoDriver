FactoryGirl.define do
  factory :user do
    username 'Test_user'
    password '12345678'
    email 't@t.pl'
    engine_type_id 1
    engine_displacement_id 1
  end
end
