class ChallengesUser < ActiveRecord::Base
  def self.create_unique(user_id, challenge_id)
    return false if find_by(user_id: user_id,
                            challenge_id: challenge_id).blank?
    create(user_id: user_id,
           challenge_id: challenge_id)
    true
  end
end
