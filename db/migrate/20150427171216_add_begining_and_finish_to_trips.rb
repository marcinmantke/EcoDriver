class AddBeginingAndFinishToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :beginning, :string, null: false
    add_column :trips, :finish, :string, null: false
  end
end
