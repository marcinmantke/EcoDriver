class ChallengesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge

  def self.create_unique(user_id, challenge_id)
    return false unless where(user_id: user_id,
                              challenge_id: challenge_id).blank?
    create(user_id: user_id,
           challenge_id: challenge_id)
    true
  end
end
