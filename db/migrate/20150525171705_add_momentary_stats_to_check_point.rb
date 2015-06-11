class AddMomentaryStatsToCheckPoint < ActiveRecord::Migration
  def change
    add_column :check_points, :rpm, :integer, null: false
    add_column :check_points, :speed, :integer, null: false
    add_column :check_points, :fuel_consumption, :float, null: false
    add_column :check_points, :gear, :integer, null: false
  end
end
