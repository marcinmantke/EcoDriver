class Trip < ActiveRecord::Base
  belongs_to :engine_displacement
  belongs_to :engine_type
  belongs_to :user
  has_many :check_points
  belongs_to :challenge

  after_create :match_with_challenge

  def self.all_by_condition(condition)
    hash_trips = []
    trips = Trip.all.includes(:engine_type, :engine_displacement)
            .where(condition)
            .references(:engine_types, :engine_displacements)
            .order(avg_fuel: :asc)
    trips.each do |trip|
      hash_trips.push trip.to_hash
    end
    hash_trips
  end

  def to_hash
    hash_trip = serializable_hash
    hash_trip.merge!(datetime_formatted)
    hash_trip[:user] = user.username
    hash_trip[:engine_displacement] = engine_displacement.disp
    hash_trip[:engine_type] = engine_type.eng_type
    hash_trip
  end

  def datetime_formatted
    hash = {
      date: date.strftime('%F'),
      time: date.strftime('%R')
    }
    hash
  end

  def path_formated
    path = []
    check_points.each do |check_point|
      path.push([])
      path.last.push(check_point['latitude'])
      path.last.push(check_point['longitude'])
    end
    path
  end

  def match_with_challenge
    ChallengesUser.create_unique(user.id, id) unless challenge_id.nil?
  end
end
