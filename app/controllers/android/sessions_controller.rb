class Android
  class SessionsController < Devise::SessionsController
    include ControllerUtil

    respond_to :json

    def create
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      response = { success: true,
                   data: { engine_type_id: current_user.engine_type_id,
                           engine_displacement_id:
                            current_user.engine_displacement_id } }

      json_respond_formatter(response)
    end

    def destroy
      (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      response = {  success: true, data: false }

      json_respond_formatter(response)
    end
  end
end
