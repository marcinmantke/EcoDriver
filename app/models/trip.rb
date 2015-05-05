class Trip < ActiveRecord::Base
	belongs_to :car_type
	belongs_to :user
  has_many :check_points
  belongs_to :challenge
end
