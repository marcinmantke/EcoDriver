class AddEngineDisplacementTable < ActiveRecord::Migration
  def change
    create_table :engine_displacements do |t|
      t.string :disp
    end
  end
end
