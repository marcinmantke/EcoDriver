class AddRecordedAtToCheckPoint < ActiveRecord::Migration
  def change
    add_column :check_points, :recorded_at, :float, null: false
  end
end
