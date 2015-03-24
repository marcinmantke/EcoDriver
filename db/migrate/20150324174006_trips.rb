class Trip < ActiveRecord::Migration

  def change
  	create_table :trips do |t|
  		t.float :distance, null: false
  		t.float :avg_speed, null: false
  		t.float :avg_rpm, null: false
  		t.float :avg_fuel, null: false
  		t.datetime :date, null: false
	end
  end
end
