class Invitation < ActiveRecord::Base
  belongs_to :invited_by, class_name: 'User'
  belongs_to :user
  belongs_to :challenge

  def self.create_unique(invited_by_id, user_id, challenge_id)
    invitation = where(
      invited_by_id: invited_by_id,
      user_id: user_id,
      challenge_id: challenge_id
    )
    return false unless invitation.blank? &&
                        !User.find(user_id).challenges
                         .include?(Challenge.find challenge_id)

    create(
      invited_by_id: invited_by_id,
      user_id: user_id,
      challenge_id: challenge_id)
    true
  end
end
