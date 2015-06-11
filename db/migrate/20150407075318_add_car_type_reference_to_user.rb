class AddCarTypeReferenceToUser < ActiveRecord::Migration
  def change
    add_reference :users, :car_type, index: true
  end
end
