class CreateUserChallenges < ActiveRecord::Migration
  def change
    create_join_table :users, :challenges do |t|
      t.index :user_id
      t.index :challenge_id
    end
  end
end
