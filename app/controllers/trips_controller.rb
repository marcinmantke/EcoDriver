# encoding: UTF-8
class TripsController < ApplicationController

before_action :authenticate_user!

  def index
  end

  def show
    @trip=Trip.find(params.permit(:id)["id"])
    render json: @trip
  end

  def create
    begin
      @trip = Trip.new(params.require(:trip).permit(:distance, :avg_rpm, :avg_fuel, :avg_speed, :date, :mark))

      raise ArgumentError, "engine_types can't be empty" if current_user.engine_type_id.nil?
      raise ArgumentError, "engine_displacements can't be empty" if current_user.engine_displacement_id.nil?

      @trip.engine_type_id = current_user.engine_type_id
      @trip.engine_displacement_id = current_user.engine_displacement_id
      @trip.user_id = current_user.id

      beginning = params[:trip][:path].first[:latitude].to_s + ',' + params[:trip][:path].first[:longitude].to_s
      finish = params[:trip][:path].last[:latitude].to_s + ',' + params[:trip][:path].last[:longitude].to_s

      @trip.beginning = geocoderWrapper(beginning).address
      @trip.finish = geocoderWrapper(finish).address

      params[:trip][:path].each do |point|
        CheckPoint.create(longitude: point[:longitude], latitude: point[:latitude], trip: @trip)
      end

      @trip.save

      response = { data: @trip,
                    success: true }
    rescue Exception => exc
      response = { data: exc.message,
                    success: false }
    end

    respond_to do |format|
      format.html {  raise ActionController::RoutingError.new('Not Found') }
      format.json { render json: response }
    end
  end

  def geocoderWrapper(latlng)
    begin
      return Geocoder.search(latlng).first
    rescue Exception => exc
      puts exc
      sleep 1
      geocoderWrapper(latlng)
    end
  end

  def dashboard
    engine_type = EngineType.find(current_user.engine_type_id)
    engine_disp = EngineDisplacement.find(current_user.engine_displacement_id)
    trips_number = Trip.where(user_id: current_user.id).count
    mileage = Trip.where(user_id: current_user.id).sum(:distance)
    avg_fuel = Trip.where(user_id: current_user.id).average(:avg_fuel)
    avg_speed = Trip.where(user_id: current_user.id).average(:avg_speed)

    results=[]
    results.push({
      engine: engine_type.eng_type,
      disp: engine_disp.disp,
      trips_number: trips_number,
      mileage: mileage.round(2),
      avg_fuel: avg_fuel.round(2),
      avg_speed: avg_speed.round(2)
    })

    respond_to do |format|
        format.html {  raise ActionController::RoutingError.new('Not Found') }
        format.json { render json: results }
    end
  end

  def mytrips
    trips=Trip.where(user_id: current_user.id).order(date: :desc)

    trips_to_render=[]
    trips.each do |trip|
      path = []
      CheckPoint.where(trip: trip).each do |check_point|
        path.push([])
        path.last.push(check_point["latitude"])
        path.last.push(check_point["longitude"])
      end

      trips_to_render.push({
        id: trip.id,
        distance: trip.distance.round(2),
        avg_rpm: trip.avg_rpm.round(2) ,
        avg_fuel: trip.avg_fuel.round(2) ,
        avg_speed: trip.avg_speed.round(2) ,
        date: trip.date.strftime("%F"),
        time: trip.date.strftime("%R"),
        beginning: trip.beginning,
        finish: trip.finish,
        user: trip.user.username,
        engine_type: trip.engine_type.eng_type,
        engine_displacement: trip.engine_displacement.disp ,
        path: path,
        mark: trip.mark,
        challenge: trip.challenge
        })
    end

    respond_to do |format|
        format.html {  raise ActionController::RoutingError.new('Not Found') }
        format.json { render json: trips_to_render }
      end
    end

  def getTripsByCarType
    trips=Trip.includes(:engine_type, :engine_displacement).where("engine_types.eng_type = ?", params.permit(:engine_type)["engine_type"])
      .where("engine_displacements.disp = ?", params.permit(:engine_displacement)["engine_displacement"])
      .references(:engine_types, :engine_displacements)

    trips_to_render=[]
    trips.each do |trip|
      trips_to_render.push({
        distance: trip.distance,
        avg_rpm: trip.avg_rpm ,
        avg_fuel: trip.avg_fuel ,
        avg_speed: trip.avg_speed ,
        date: trip.date.strftime("%F") ,
        user: trip.user.username ,
        engine_displacement: trip.engine_displacement.disp,
        engine_type: trip.engine_type.eng_type,
        mark: trip.mark
        })
    end

    render json: trips_to_render
  end

  def getTripsByDistance
    trips=Trip.includes(:engine_type, :engine_displacement).where("distance > ?", params.permit(:lower_limit)["lower_limit"])
      .where("distance <= ?", params.permit(:upper_limit)["upper_limit"])
      .references(:engine_types, :engine_displacements).order(:avg_fuel)

    trips_to_render=[]
    trips.each do |trip|
      trips_to_render.push({
        distance: trip.distance,
        avg_rpm: trip.avg_rpm ,
        avg_fuel: trip.avg_fuel ,
        avg_speed: trip.avg_speed ,
        date: trip.date.strftime("%F") ,
        user: trip.user.username ,
        engine_displacement: trip.engine_displacement.disp ,
        engine_type: trip.engine_type.eng_type,
        mark: trip.mark
        })
    end

    render json: trips_to_render
  end

  def WhoAmI
    if user_signed_in?
      response = { success: true, data: current_user.username }
    else
      response = { succsess: false, data: "You have to be logged in." }
    end

    respond_to do |format|
      format.html {  raise ActionController::RoutingError.new('Not Found') }
      format.json { render json: response }
    end
  end

end
