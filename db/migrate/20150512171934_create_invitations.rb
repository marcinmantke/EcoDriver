class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :invited_by, references: :users, null: false
      t.references :user, null: false
      t.references :challenge, null: false
      t.timestamps
    end
  end
end
