class CheckPointFloatToDecimal < ActiveRecord::Migration
  def change
    change_column :check_points, :latitude, :decimal, precision: 23, scale: 20
    change_column :check_points, :longitude, :decimal, precision: 23, scale: 20
  end
end
