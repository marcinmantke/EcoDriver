class CreateFuelConsumptions < ActiveRecord::Migration
  def change
    create_table :fuel_consumptions do |t|
      t.references :engine_displacement, null: false
      t.references :engine_type, null: false
      t.float :low, null: false
      t.float :high, null: false
      t.timestamps
    end
  end
end
