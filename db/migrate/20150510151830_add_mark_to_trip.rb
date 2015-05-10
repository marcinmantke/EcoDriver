class AddMarkToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :mark, :decimal, precision: 4, scale: 2
  end
end
