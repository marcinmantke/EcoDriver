FactoryGirl.define do
  factory :challenge do
    finish_date Time.zone.tomorrow
    trip_id 1
    start_point 2
    finish_point 4
  end
  factory :challenge_without_points, class: Hash do
    finish_date Time.zone.tomorrow
    trip_id 1
  end
end
