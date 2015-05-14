class Android::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    response = {  success: true, data: { engine_type_id: current_user.engine_type_id, engine_displacement_id: current_user.engine_displacement_id } }

    respond_to do |format|
      format.html {  raise ActionController::RoutingError.new('Not Found') }
      format.json { render json: response }
    end
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    response = {  success: true, data: false }

    respond_to do |format|
      format.html {  raise ActionController::RoutingError.new('Not Found') }
      format.json { render json: response }
    end
  end
end
