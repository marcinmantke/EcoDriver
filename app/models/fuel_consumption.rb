class FuelConsumption < ActiveRecord::Base
  belongs_to :engine_type
  belongs_to :engine_displacement
end
