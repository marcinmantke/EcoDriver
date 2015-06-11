class AddChallengeReferenceToTrips < ActiveRecord::Migration
  def change
    add_reference :trips, :challenge, index: true
  end
end
