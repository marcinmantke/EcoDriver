class Challenge < ActiveRecord::Base
  belongs_to :route, class_name: 'Trip'
  has_many :trips
  has_many :challenges_user
  has_many :users, through: :challenges_user
  has_many :invitations

  after_create :update_route

  def self.all_for_user(user_id)
    hash_challenges = []
    challenges = all.order(created_at: :desc)

    challenges.each do |challenge|
      hash_challenges.push challenge.to_hash user_id
    end
    hash_challenges
  end

  def to_hash(user_id)
    hash_challenge = serializable_hash
    hash_challenge['created_by'] = route.user.username
    hash_challenge['is_joined'] = joined?(user_id)
    hash_challenge['route'] = route.serializable_hash
    hash_challenge
  end

  def joined?(user_id)
    user_challenges = ChallengesUser.select(:challenge_id)
                      .where(user_id: user_id).collect(&:challenge_id)
    return 1 if user_challenges.include?(id)
    0
  end

  def update_route
    route.update(challenge_id: id)
    ChallengesUser.create_unique(route.user.id, id)
  end

  def self.create_from_params(params)
    route = Trip.find(params[:trip_id])
    if Challenge.check_start_finish(params)
      params[:start_point] = 0
      params[:finish_point] = route.check_points.count - 1
    end
    Challenge.create(route: route,
                     finish_date: params[:finish_date],
                     start_point: params[:start_point],
                     finish_point: params[:finish_point])
  end

  def self.check_start_finish(params)
    params[:start_point].nil? || params[:finish_point].nil? ||
      params[:start_point] == params[:finish_point]
  end

  def path
    path = route.check_points.to_a
    if start_point < finish_point
      path = path[start_point..finish_point]
    else
      path.reverse!
      path = path[finish_point..start_point]
    end
    path
  end
end
