class EngineDisplacement < ActiveRecord::Base
  has_one :users
  has_many :trips
end
