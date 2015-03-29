class TripsController < ApplicationController

	def index
		@trips=Trip.all
		render :json=>@trips
	end

	def show
		@trip=Trip.find(params.permit(:id)["id"])
		render :json=>@trip
	end

	def create
		@trip = Trip.new(params.permit(:distance, :avg_rpm, :avg_fuel, :avg_speed, :date, :user_id))
		@trip.save
		render :json =>@trip
	end

	def getTripsByCarType
		trips=Trip.includes(:car_type).where("car_types.engine_type = ?", params.permit(:engine_type)["engine_type"])
			.where("car_types.engine_displacement = ?", params.permit(:engine_displacement)["engine_displacement"]).references(:car_types)
		render :json => trips
	end

end
