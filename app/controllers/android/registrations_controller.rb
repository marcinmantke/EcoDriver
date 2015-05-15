class Android
  class RegistrationsController < Devise::RegistrationsController
    include ControllerUtil
    def create
      build_resource(sign_up_params)

      if resource.save
        sign_in resource
        response = { success: true,
                     data: resource,
                     engine_type_id: current_user.engine_type_id,
                     engine_displacement_id:
                      current_user.engine_displacement_id }
      else
        response = { success: false,
                     data: resource.errors }
      end

      json_respond_formatter(response)
    end
  end
end
