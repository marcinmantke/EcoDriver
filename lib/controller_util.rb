module ControllerUtil
  def json_respond_formatter(response)
    respond_to do |format|
      format.html { fail ActionController::RoutingError.new('Not Found') }
      format.json { render json: response }
    end
  end
end
