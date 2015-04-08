class Android::UsersController < ApplicationController

before_action :authenticate_user!


	def updateCarType
		if user_signed_in?
			current_user.update(params.permit(:car_type_id))
			render :json => {success: true}
		else
			render :json => {success: false}
		end
	end
end
