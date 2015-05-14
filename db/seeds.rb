# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# EngineType.create(eng_type: 'diesel', gear_up_min: 2000, gear_up_max: 2200, gear_down: 1700)
# EngineType.create(eng_type: 'gas', gear_up_min: 2300, gear_up_max: 2500, gear_down: 1800)
# EngineType.create(eng_type: 'petrol', gear_up_min: 2300, gear_up_max: 2500, gear_down: 1800)
#
# EngineDisplacement.create(disp: '<1.0')
# EngineDisplacement.create(disp: '1.0-1.5')
# EngineDisplacement.create(disp: '1.6-2.0')
# EngineDisplacement.create(disp: '2.1-2.5')
# EngineDisplacement.create(disp: '2.6-3.0')
# EngineDisplacement.create(disp: '>3.0')

#Trip.update_all(:engine_type_id => rand(1..3),:engine_displacement_id => rand(1..6))

Trip.update_all(mark: 5.00)
