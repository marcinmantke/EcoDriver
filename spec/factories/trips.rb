FactoryGirl.define do
  factory :trip do
    distance 100
    avg_rpm 2500
    avg_speed 94
    avg_fuel 8.9
    date '12.12.2012'
  end

  factory :trip_with_path, class: Hash do
    distance 100
    avg_rpm 2500
    avg_speed 94
    avg_fuel 8.9
    date '12.12.2012'
    path [{ 'longitude' => '12.0',
            'latitude' => '-48.00312' },
          { 'longitude' => '11.0',
            'latitude' => '-47.00312' }]

    initialize_with { attributes }
  end
end
