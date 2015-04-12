class Android::UsersController < ApplicationController

before_action :authenticate_user!


	def updateCarType
		if user_signed_in?
			current_user.update(params.permit(:car_type_id))
			response = {success: true}
		else
			response = {success: false}
		end

    respond_to do |format|
      format.html {  raise ActionController::RoutingError.new('Not Found') }
      format.json { render json: response }
    end
	end
end
