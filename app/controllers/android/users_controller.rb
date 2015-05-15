class Android
  class UsersController < ApplicationController
    include ControllerUtil
    before_action :authenticate_user!

    def update_car_type
      if user_signed_in?
        current_user
          .update(params.permit(:engine_type_id, :engine_displacement_id))
        response = { success: true }
      else
        response = { success: false }
      end

      json_respond_formatter(response)
    end

    def gear_params
      return unless user_signed_in?
      results = []
      results.push(gear_up_min: current_user.engine_type.gear_up_min,
                   gear_up_max: current_user.engine_type.gear_up_max,
                   gear_down: current_user.engine_type.gear_down)

      json_respond_formatter(response)
    end
  end
end
