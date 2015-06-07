FactoryGirl.define do
  factory :check_point, class: CheckPoint do
    longitude 149.12881
    latitude 35.28302
    rpm 1000
    speed 121
    fuel_consumption 9.9
    gear 1
    trip_id 2
    recorded_at 1
  end
end
