class AddStartPointAndFinishPointToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :start_point, :integer, null: false
    add_column :challenges, :finish_point, :integer, null: false
  end
end
