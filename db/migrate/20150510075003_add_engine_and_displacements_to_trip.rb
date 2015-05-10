class AddEngineAndDisplacementsToTrip < ActiveRecord::Migration
  def change
      remove_reference :trips, :car_type
      add_reference :trips, :engine_type, index: true
      add_reference :trips, :engine_displacement, index: true
  end
end
