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

	def mytrips
		if user_signed_in?
    		@trip = Trip.where(user_id: current_user.id)
    		render :json=>@trip
    	else
    		render :json=>"You have to be logged in."
    	end
  	end
end
