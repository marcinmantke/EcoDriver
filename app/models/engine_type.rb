class EngineType < ActiveRecord::Base
  has_one :users
  has_many :trips
  has_many :fuel_consumptions

  def color(avg_rpm)
    if avg_rpm > gear_down && avg_rpm <= gear_up_min
      return 'green'
    elsif avg_rpm > gear_up_min && avg_rpm < gear_up_max
      return 'yellow'
    else
      return 'red'
    end
  end
end
