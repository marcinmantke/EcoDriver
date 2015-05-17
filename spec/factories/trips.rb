FactoryGirl.define do
  factory :trip do
    distance 100
    avg_rpm 2500
    avg_speed 94
    avg_fuel 8.9
    date '2015-05-14T21:23:11.510Z'
    mark 5.0
  end

  factory :trip_with_path, class: Hash do
    distance 100
    avg_rpm 2500
    avg_speed 94
    avg_fuel 8.9
    date '2015-05-14T21:23:11.510Z'
    mark 5.0
    path [{ 'longitude' => '12.0',
            'latitude' => '-48.00312' },
          { 'longitude' => '11.0',
            'latitude' => '-47.00312' }]

    initialize_with { attributes }
  end

  factory :trip_with_challenge, class: Hash do
    distance 100
    avg_rpm 2500
    avg_speed 94
    avg_fuel 8.9
    challenge_id 1
    date '2015-05-14T21:23:11.510Z'
    mark 5.0
    path [{ 'longitude' => '12.0',
            'latitude' => '-48.00312' },
          { 'longitude' => '11.0',
            'latitude' => '-47.00312' }]

    initialize_with { attributes }
  end

  factory :full_trip, class: Trip do
    distance 100
    avg_rpm 2500
    avg_speed 94
    avg_fuel 8.9
    date '2015-05-14T21:23:11.510Z'
    mark 5.0
    user_id 1
    beginning 'Start'
    finish 'Finish'
    challenge_id nil
    engine_type_id 1
    engine_displacement_id 1
  end
end
