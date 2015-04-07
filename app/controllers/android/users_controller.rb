class Android::UsersController < ApplicationController

	def updateCarType
		if user_signed_in?
			current_user.update(params.permit(:car_type_id))
			render :json => {success: true}
		else
			render :json => {success: false}
		end
	end
end
