class Android::SessionsController < Devise::SessionsController


	def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    yield resource if block_given?
     render  :status => 200,
                :json => {  :success => true }

  end
end