module ControllerUtil
  def json_respond_formatter(response)
    respond_to do |format|
      format.html { fail ActionController::RoutingError.new('Not Found') }
      format.json { render json: response }
    end
  end

  def prepare_condition(engine_type, engine_displacement,
    lower_limit, upper_limit)
    conditions = []
    unless engine_type.nil?
      engine_type_id = EngineType.find_by(eng_type: engine_type).id
      conditions.push "engine_type_id = '#{engine_type_id}'"
    end
    unless engine_displacement.nil?
      engine_disp_id = EngineDisplacement.find_by(disp: engine_displacement).id
      conditions.push "engine_displacement_id = '#{engine_disp_id}'"
    end
    unless lower_limit.nil? && upper_limit.nil?
      conditions.push "SUM(distance) > #{lower_limit} AND
        SUM(distance) <= #{upper_limit}"
    end
    conditions_to_string(conditions)
  end

  def conditions_to_string(conditions)
    condition_string = ''
    conditions.each do |condition|
      condition_string << condition
      condition_string << ' AND ' unless condition.equal? conditions.last
    end
    condition_string
  end
end
