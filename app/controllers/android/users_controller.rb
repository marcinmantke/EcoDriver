class Android::UsersController < ApplicationController
  before_action :authenticate_user!

  def update_car_type
    if user_signed_in?
      current_user.update(params.permit(:engine_type_id, :engine_displacement_id))
      response = { success: true }
    else
      response = { success: false }
    end

    respond_to do |format|
      format.html {  fail ActionController::RoutingError.new('Not Found') }
      format.json { render json: response }
    end
  end

  def get_gear_params
    if user_signed_in?
      results = []
      results.push({
        gear_up_min: current_user.engine_type.gear_up_min,
        gear_up_max: current_user.engine_type.gear_up_max,
        gear_down: current_user.engine_type.gear_down
      })

      respond_to do |format|
        format.html {  fail ActionController::RoutingError.new('Not Found') }
        format.json { render json: results }
      end
    end
  end
end
