class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username,
            presence: true,
            uniqueness: {
              case_sensitive: false
            }

  has_many :trips, dependent: :destroy
  belongs_to :engine_type
  belongs_to :engine_displacement

  has_many :challenges_user
  has_many :challenges, through: :challenges_user
  has_many :invitations

  attr_accessor :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    if login
      where(conditions)
        .find_by(['lower(username) = :value OR lower(email) = :value',
                  { value: login.downcase }])
    else
      if conditions[:username].nil?
        find_by(conditions)
      else
        find_by(username: conditions[:username])
      end
    end
  end

  def formatted_trips
    hash_trips = []
    trips.order(date: :desc).each do |trip|
      hash_trips.push trip.to_hash
      hash_trips.last[:path] = trip.path_formated
      hash_trips.last[:challenge] = trip.challenge
    end
    hash_trips
  end

  def stats
    {
      engine: engine_type.eng_type,
      disp: engine_displacement.disp,
      trips_number: trips.count,
      mileage: trips.sum(:distance).round(2),
      avg_fuel: trips.average(:avg_fuel).round(2),
      avg_speed: trips.average(:avg_speed).round(2)
    }
  end

  def invitations_challenges
    challenges = []
    invitations.each do |invitation|
      challenges.push invitation.challenge.to_hash id
      challenges.last[:invitation_id] = invitation.id
    end
    challenges
  end
end
