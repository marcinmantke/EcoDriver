class ChangeTableNameCarType < ActiveRecord::Migration
  def change
    rename_table :car_types, :engine_types
    change_table :engine_types do |t|
      t.rename :engine_type, :type
      t.remove :engine_displacement
      t.integer :gear_up_min
      t.integer :gear_up_max
      t.integer :gear_down
    end
  end
end
