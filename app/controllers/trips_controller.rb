class TripsController < ApplicationController

	def index
		@trips=Trip.all
		render :json=>@trips
	end

	def show
		@trip=Trip.find(params.permit(:id)["id"])
		render :json=>@trip
	end

end
