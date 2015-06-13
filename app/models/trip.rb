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

  def self.ranking(condition)
    hash_trips = []
    trips = Trip.group(:engine_type_id)
            .group(:engine_displacement_id)
            .group(:user_id)
            .references(:engine_displacement, :engine_type)
            .select('date, AVG(avg_fuel) as avg_fuel,
              AVG(avg_speed) as avg_speed, AVG(avg_rpm) as avg_rpm,
              SUM(distance) as distance, AVG(mark) as mark,
              user_id, engine_type_id, engine_displacement_id')
            .having(condition)

    trips.each do |trip|
      hash_trips.push trip.to_hash
      hash_trips.last[:colors] = trip.colors
    end
    hash_trips.sort_by { |hsh| hsh[:avg_fuel] }
  end

  def colors
    color = {}
    color[:fuel] =
    FuelConsumption.find_by(engine_type:
                              engine_type,
                            engine_displacement:
                              engine_displacement)
    .color(avg_fuel)
    color[:rpm] = engine_type.color(avg_fuel)
    color
  end

  def to_hash
    hash_trip = serializable_hash
    hash_trip.merge!(datetime_formatted)
    hash_trip.merge!(engine_info)
    hash_trip.merge!(stats_formatted)
    hash_trip[:user] = user.username

    hash_trip
  end

  def stats_formatted
    hash = {
      avg_fuel: avg_fuel.round(1),
      avg_rpm: avg_rpm.round(0),
      distance: distance.round(2),
      mark: mark.round(1)
    }
    hash
  end

  def engine_info
    hash = {
      engine_displacement: engine_displacement.disp,
      engine_type: engine_type.eng_type
    }
    hash
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
      path.push(check_point.serializable_hash)
    end
    path
  end

  def match_with_challenge
    ChallengesUser.create_unique(user.id, challenge_id) unless challenge_id.nil?
  end

  def economic_ranges
    FuelConsumption.find_by(
      engine_type: engine_type,
      engine_displacement: engine_displacement).economic_ranges
  end
end
