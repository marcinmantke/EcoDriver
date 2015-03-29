class RenameTableCarTypes < ActiveRecord::Migration
  def change
  	rename_table :car_type, :car_types
  end
end
