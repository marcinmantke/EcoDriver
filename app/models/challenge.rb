class Challenge < ActiveRecord::Base
  belongs_to :route, :class_name => "Trip"
  has_many :trips
end
