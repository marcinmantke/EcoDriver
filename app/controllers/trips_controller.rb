# encoding: UTF-8
class TripsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
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
                 trace: exc.backtrace.join(';'),
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
    conditions = prepare_condition(params[:engine_type],
                                   params[:engine_displacement],
                                   params[:lower_limit],
                                   params[:upper_limit])
    json_respond_formatter(Trip.ranking(conditions))
  end

  def prepare_condition(engine_type, engine_displacement,
    lower_limit, upper_limit)
    conditions = []
    unless engine_type.nil?
      engine_type_id = EngineType.find_by(eng_type: engine_type).id
      conditions.push "engine_type_id = '#{engine_type_id}'"
    end
    unless engine_displacement.nil?
      engine_disp_id = EngineDisplacement.find_by(disp: engine_displacement).id
      conditions.push "engine_displacement_id = '#{engine_disp_id}'"
    end
    unless lower_limit.nil? && upper_limit.nil?
      conditions.push "SUM(distance) > #{lower_limit} AND
        SUM(distance) <= #{upper_limit}"
    end
    conditions
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
