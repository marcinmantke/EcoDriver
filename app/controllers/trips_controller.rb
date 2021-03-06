# encoding: UTF-8
class TripsController < ApplicationController # rubocop:disable ClassLength
  before_action :authenticate_user!, except: [:index, :trip_path]
  include ControllerUtil

  def index
    redirect_to '/login' unless user_signed_in?
  end

  def show
    @trip = Trip.find(params.permit(:id)['id'])
    render json: @trip
  end

  def create
    check_car_params
    @trip = Trip.new(params.require(:trip).permit(:distance,
                                                  :avg_rpm,
                                                  :avg_fuel,
                                                  :avg_speed,
                                                  :challenge_id,
                                                  :date, :mark))
    json_respond_formatter fill_and_save params[:trip][:path]
  rescue StandardError => exc
    response = { data: exc.message,
                 success: false }
    json_respond_formatter response
  end

  def check_car_params
    response = { success: false }
    json_respond_formatter response if current_user.engine_type_id.nil? ||
                                       current_user.engine_displacement_id.nil?
  end

  def fill_and_save(path)
    fill_user_data
    find_starat_finish(path)
    CheckPoint.create_path(path, @trip)
    @trip.save
    response = { data: @trip, success: true }
    response
  end

  def fill_user_data
    @trip.engine_type_id = current_user.engine_type_id
    @trip.engine_displacement_id = current_user.engine_displacement_id
    @trip.user_id = current_user.id
  end

  def find_starat_finish(path)
    beginning = point_to_string path.first
    finish = point_to_string path.last
    @trip.beginning = geocoder_wrapper(beginning).address
    @trip.finish = geocoder_wrapper(finish).address
  end

  def point_to_string(point)
    "#{point[:latitude]},#{point[:longitude]}"
  end

  def geocoder_wrapper(latlng)
    return Geocoder.search(latlng).first
  rescue StandardError
    sleep 1
    geocoder_wrapper(latlng)
  end

  def dashboard
    json_respond_formatter current_user.stats
  end

  def mytrips
    json_respond_formatter(current_user.formatted_trips)
  end

  def ranking
    condition = prepare_condition(params[:engine_type],
                                  params[:engine_displacement],
                                  params[:lower_limit],
                                  params[:upper_limit])
    json_respond_formatter(Trip.ranking(condition))
  end

  def who_am_i
    if user_signed_in?
      response = { success: true, data: current_user.username }
    else
      response = { succsess: false, data: 'You have to be logged in.' }
    end

    respond_to do |format|
      format.html {  fail ActionController::RoutingError.new('Not Found') }
      format.json { render json: response }
    end
  end

  def economic_ranges
    fuel_consumption = FuelConsumption
                       .where(engine_type_id: params[:eng_type],
                              engine_displacement_id: params[:eng_disp]).first
    data = {
      fuel_consumption: fuel_consumption,
      engine_type: fuel_consumption.engine_type
    }
    response = { success: true, data: data }

    respond_to do |format|
      format.html {  fail ActionController::RoutingError.new('Not Found') }
      format.json { render json: response }
    end
  end

  def trip_path
    user_trip_id = best_user_trip(params[:challenge_id])
    data = assign_path_from_trip(params[:id_best],
                                 params[:id_worst],
                                 user_trip_id)
    json_respond_formatter(data)
  end

  def best_user_trip(challenge_id)
    best_user_trip = Trip
                     .where(user_id: current_user.id,
                            challenge_id: challenge_id)
                     .order(avg_fuel: :asc).first
    if best_user_trip.nil?
      id = nil
    else
      id = best_user_trip.id
    end
    id
  end

  def assign_path_from_trip(id_best, id_worst, id_user)
    data = []
    path_best = CheckPoint.get_path(id_best) unless id_best.nil?
    path_worst = CheckPoint.get_path(id_worst) unless id_worst.nil?
    path_user = CheckPoint.get_path(id_user) unless id_user.nil?
    data.push(path_best)
    data.push(path_worst)
    data.push(path_user)
    data
  end
end
