class Android::RegistrationsController < Devise::RegistrationsController

  respond_to :json
  def create
    build_resource(sign_up_params)

    if resource.save
      sign_in resource
      render :status => 200,
           :json => { :success => true,
                      :info => "Registered",
                      :data => resource,
                      :car_type_id => current_user.car_type_id }
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => resource.errors,
                        :data => {} }
    end
  end

end