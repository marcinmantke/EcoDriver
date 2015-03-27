# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Trip.create(distance: 1.1, avg_rpm: 1000, avg_fuel: 11, avg_speed: 100, date: Date.today, user_id: 1)
Trip.create(distance: 2.1, avg_rpm: 2000, avg_fuel: 12, avg_speed: 110, date: Date.today, user_id: 1)
Trip.create(distance: 3.1, avg_rpm: 3000, avg_fuel: 13, avg_speed: 120, date: Date.today, user_id: 1)
Trip.create(distance: 4.1, avg_rpm: 4000, avg_fuel: 14, avg_speed: 130, date: Date.today, user_id: 1)
Trip.create(distance: 5.1, avg_rpm: 5000, avg_fuel: 15, avg_speed: 140, date: Date.today, user_id: 1)
