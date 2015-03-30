class Trip < ActiveRecord::Base
	belongs_to :car_type
	belongs_to :user
end
