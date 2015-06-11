class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.references :route, references: :trips, null: false
      t.date :finish_date, null: false
      t.timestamps
    end
  end
end
