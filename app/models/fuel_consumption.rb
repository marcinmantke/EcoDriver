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

  def color(avg_fuel)
    if avg_fuel <= low
      return 'green'
    elsif avg_fuel > low && avg_fuel <= high
      return 'yellow'
    else
      return 'red'
    end
  end
end
