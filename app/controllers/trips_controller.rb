class TripsController < ApplicationController

before_action :authenticate_user!

	def index
	end

	def show
		@trip=Trip.find(params.permit(:id)["id"])
		render :json=>@trip
	end

	def create
		begin
			@trip = Trip.new(params.require(:trip).permit(:distance, :avg_rpm, :avg_fuel, :avg_speed, :date))

			raise ArgumentError, "car_type can't be empty" if current_user.car_type_id.nil?

			@trip.car_type_id = current_user.car_type_id
			@trip.user_id = current_user.id
			

			params[:trip][:path].each do |point|
				CheckPoint.create(longitude: point[:longitude], latitude: point[:latitude], trip: @trip)
			end

			@trip.save

			render :json =>@trip
		rescue Exception => exc
			render :json=> {status: 500, error: exc.message}
    end
	end

	def mytrips
		trips=Trip.where(user_id: current_user.id)

		trips_to_render=[]
		trips.each do |trip|
			trips_to_render.push({
				distance: trip.distance,
				avg_rpm: trip.avg_rpm ,
				avg_fuel: trip.avg_fuel ,
				avg_speed: trip.avg_speed ,
				date: trip.date.strftime("%F") ,
				user: trip.user.username ,
				engine_displacement: trip.car_type.engine_displacement ,
				engine_type: trip.car_type.engine_type
				})
		end

		respond_to do |format|
			  format.html {  raise ActionController::RoutingError.new('Not Found') }
			  format.json { render json: trips_to_render }
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
				date: trip.date.strftime("%F") ,
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
				date: trip.date.strftime("%F") ,
				user: trip.user.username ,
				engine_displacement: trip.car_type.engine_displacement ,
				engine_type: trip.car_type.engine_type
				})
		end

		render :json => trips_to_render
	end

	def WhoAmI
		if user_signed_in?
			response = current_user.username
		else
			response = {status: 500, info: "You have to be logged in."}
		end

		respond_to do |format|
		  format.html {  raise ActionController::RoutingError.new('Not Found') }
		  format.json { render json: response }
		end
	end


end
