class CreateCarTypeModel < ActiveRecord::Migration
  def change
    create_table :car_type do |t|
      t.string :engine_type
      t.string :engine_displacement
    end
  end
end
