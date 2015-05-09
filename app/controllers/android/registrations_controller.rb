class Android::RegistrationsController < Devise::RegistrationsController

  def create
    build_resource(sign_up_params)

    if resource.save
      sign_in resource
      response = { :success => true,
                      :data => resource,
                      :car_type_id => current_user.car_type_id }
    else
      response = { :success => false,
                    :data => resource.errors }
    end

    respond_to do |format|
      format.html {  raise ActionController::RoutingError.new('Not Found') }
      format.json { render json: response }
    end
  end

end