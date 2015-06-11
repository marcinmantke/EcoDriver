class AddEngineTablesToUser < ActiveRecord::Migration
  def change
    remove_reference :users, :car_type
    add_reference :users, :engine_type, index: true
    add_reference :users, :engine_displacement, index: true
  end
end
