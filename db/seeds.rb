# EngineType.create(eng_type: 'diesel',
#  gear_up_min: 2000, gear_up_max: 2200, gear_down: 1700)
# EngineType.create(eng_type: 'LPG',
#  gear_up_min: 2300, gear_up_max: 2500, gear_down: 1800)
# EngineType.create(eng_type: 'petrol',
#  gear_up_min: 2300, gear_up_max: 2500, gear_down: 1800)
#
# EngineDisplacement.create(disp: '<1.0')
# EngineDisplacement.create(disp: '1.0-1.5')
# EngineDisplacement.create(disp: '1.6-2.0')
# EngineDisplacement.create(disp: '2.1-2.5')
# EngineDisplacement.create(disp: '2.6-3.0')
# EngineDisplacement.create(disp: '>3.0')

# Trip.update_all(:engine_type_id => rand(1..3),
#  :engine_displacement_id => rand(1..6))

# Trip.update_all(mark: 5.00)

FuelConsumption.create(engine_type_id: 1, engine_displacement_id: 1,
                       low: 5, high: 6)
FuelConsumption.create(engine_type_id: 1, engine_displacement_id: 2,
                       low: 5.5, high: 6.3)
FuelConsumption.create(engine_type_id: 1, engine_displacement_id: 3,
                       low: 6.2, high: 7)
FuelConsumption.create(engine_type_id: 1, engine_displacement_id: 4,
                       low: 7.2, high: 8)
FuelConsumption.create(engine_type_id: 1, engine_displacement_id: 5,
                       low: 8.5, high: 10)
FuelConsumption.create(engine_type_id: 1, engine_displacement_id: 6,
                       low: 11, high: 14)

FuelConsumption.create(engine_type_id: 2, engine_displacement_id: 1,
                       low: 6.5, high: 7.2)
FuelConsumption.create(engine_type_id: 2, engine_displacement_id: 2,
                       low: 7.4, high: 8.1)
FuelConsumption.create(engine_type_id: 2, engine_displacement_id: 3,
                       low: 9, high: 10)
FuelConsumption.create(engine_type_id: 2, engine_displacement_id: 4,
                       low: 11, high: 12.3)
FuelConsumption.create(engine_type_id: 2, engine_displacement_id: 5,
                       low: 13.2, high: 14.1)
FuelConsumption.create(engine_type_id: 2, engine_displacement_id: 6,
                       low: 14, high: 15)

FuelConsumption.create(engine_type_id: 3, engine_displacement_id: 1,
                       low: 5.9, high: 6.5)
FuelConsumption.create(engine_type_id: 3, engine_displacement_id: 2,
                       low: 7.5, high: 8)
FuelConsumption.create(engine_type_id: 3, engine_displacement_id: 3,
                       low: 7.9, high: 9)
FuelConsumption.create(engine_type_id: 3, engine_displacement_id: 4,
                       low: 10, high: 11)
FuelConsumption.create(engine_type_id: 3, engine_displacement_id: 5,
                       low: 11.5, high: 13)
FuelConsumption.create(engine_type_id: 3, engine_displacement_id: 6,
                       low: 14, high: 18)
