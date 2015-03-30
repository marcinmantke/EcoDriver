class AddCarTypeReferenceToTrip < ActiveRecord::Migration
  def change
  	add_reference :trips, :car_type, index: true
  end
end
