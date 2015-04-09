class TripsController < ApplicationController

before_action :authenticate_user!

	def index
	end

	def all
		@trips=Trip.all
		render :json=>@trips
	end

	def show
		@trip=Trip.find(params.permit(:id)["id"])
		render :json=>@trip
	end

	def create
		if user_signed_in?
			@trip = Trip.new(params.permit(:distance, :avg_rpm, :avg_fuel, :avg_speed, :date))
			@trip.car_type_id = current_user.car_type_id
			@trip.user_id = current_user.id
			@trip.save
			render :json =>@trip
		else
			render :json=> {status: 500, info: "You have to be logged in."}
    	end
	end

	def mytrips
		if user_signed_in?
    		@trip = Trip.where(user_id: current_user.id)
    		render :json=>@trip
    	else
    		render :json=> {status: 500, info: "You have to be logged in."}
    	end
  	end

	def getTripsByCarType
		trips=Trip.includes(:car_type).where("car_types.engine_type = ?", params.permit(:engine_type)["engine_type"])
			.where("car_types.engine_displacement = ?", params.permit(:engine_displacement)["engine_displacement"])
			.references(:car_types)

		trips_to_render=[]
		trips.each do |trip|
			trips_to_render.push({
				distance: trip.distance,
				avg_rpm: trip.avg_rpm ,
				avg_fuel: trip.avg_fuel ,
				avg_speed: trip.avg_speed ,
				date: trip.date ,
				user: trip.user.username ,
				engine_displacement: trip.car_type.engine_displacement ,
				engine_type: trip.car_type.engine_type
				})
		end

		render :json => trips_to_render
	end

	def getTripsByDistance
		trips=Trip.includes(:car_type).where("distance > ?", params.permit(:lower_limit)["lower_limit"])
			.where("distance <= ?", params.permit(:upper_limit)["upper_limit"])
			.references(:car_types).order(:avg_fuel)

		trips_to_render=[]
		trips.each do |trip|
			trips_to_render.push({
				distance: trip.distance,
				avg_rpm: trip.avg_rpm ,
				avg_fuel: trip.avg_fuel ,
				avg_speed: trip.avg_speed ,
				date: trip.date ,
				user: trip.user.username ,
				engine_displacement: trip.car_type.engine_displacement ,
				engine_type: trip.car_type.engine_type
				})
		end

		render :json => trips_to_render
	end

	def WhoAmI
		if user_signed_in?
			render :json => current_user.username #User.find(current_user)
		else
			{status: 500, info: "You have to be logged in."}
		end
	end

	def LoginTest
		if user_signed_in?
			render :json => 'Tekst testowy'
		else
			render :json => 'Error'
		end
	end

end
