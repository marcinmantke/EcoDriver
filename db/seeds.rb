# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#Trip.create(distance: 1.1, avg_rpm: 1000, avg_fuel: 11, avg_speed: 100, date: Date.today, user_id: 1)
#Trip.create(distance: 2.1, avg_rpm: 2000, avg_fuel: 12, avg_speed: 110, date: Date.today, user_id: 1)
#Trip.create(distance: 3.1, avg_rpm: 3000, avg_fuel: 13, avg_speed: 120, date: Date.today, user_id: 1)
#Trip.create(distance: 4.1, avg_rpm: 4000, avg_fuel: 14, avg_speed: 130, date: Date.today, user_id: 1)
#Trip.create(distance: 5.1, avg_rpm: 5000, avg_fuel: 15, avg_speed: 140, date: Date.today, user_id: 1)

EngineType.create(eng_type: 'diesel', gear_up_min: 2000, gear_up_max: 2200, gear_down: 1700) 
EngineType.create(eng_type: 'gas', gear_up_min: 2300, gear_up_max: 2500, gear_down: 1800)
EngineType.create(eng_type: 'petrol', gear_up_min: 2300, gear_up_max: 2500, gear_down: 1800)

EngineDisplacement.create(disp: '<1.0')
EngineDisplacement.create(disp: '1.0-1.5')
EngineDisplacement.create(disp: '1.6-2.0')
EngineDisplacement.create(disp: '2.1-2.5')
EngineDisplacement.create(disp: '2.6-3.0')
EngineDisplacement.create(disp: '>3.0')