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
		p @trip
		@trip.save
		render :json =>@trip
	end

end
