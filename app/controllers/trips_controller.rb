# encoding: UTF-8
class TripsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  include ControllerUtil

  def index
    redirect_to '/login' if user_signed_in?
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
  rescue StandardError
    json_respond_formatter success: false
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

  def all_trips_by_car_type
    conditions =
      "engine_types.eng_type = \'#{params['engine_type']}\'
        AND engine_displacements.disp = \'#{params['engine_displacement']}\'"
    json_respond_formatter(Trip.all_by_condition(conditions))
  end

  def all_trips_by_distance
    conditions =
      "distance > #{params['lower_limit']}
      AND distance <= #{params['upper_limit']}"
    json_respond_formatter(Trip.all_by_condition(conditions))
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
end
