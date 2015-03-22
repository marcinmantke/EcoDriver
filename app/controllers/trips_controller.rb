class TripsController < ApplicationController
	@@first_trip={
		kilometers: 20,
		average_speed: 30.5,
		average_RPM: 1200,
		average_fuel_consumption: 7.4,
		date: Date.today,
		user_id: 1
	}
	def index
	end
	def show
		render :json=>@@first_trip
	end
end
