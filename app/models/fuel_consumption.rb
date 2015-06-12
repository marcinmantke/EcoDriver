class FuelConsumption < ActiveRecord::Base
  belongs_to :engine_type
  belongs_to :engine_displacement

  def economic_ranges
    data = {
      fuel_consumption: self,
      engine_type: engine_type
    }
    data
  end
end
