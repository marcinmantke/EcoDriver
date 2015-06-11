class CreateCheckPoints < ActiveRecord::Migration
  def change
    create_table :check_points do |t|
      t.float :longitude, null: false
      t.float :latitude, null: false
      t.references :trip
      t.timestamps
    end
  end
end
