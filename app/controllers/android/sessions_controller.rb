class Android::SessionsController < Devise::SessionsController

	respond_to :json

	def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    render :status => 200,
            :json => {  :success => true }

  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    render :status => 200,
            :json => {  :success => true }
  end
end