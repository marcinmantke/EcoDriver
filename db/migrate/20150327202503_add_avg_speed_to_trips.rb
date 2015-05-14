class AddAvgSpeedToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :avg_speed, :integer, null: false
  end
end
