class EngineType < ActiveRecord::Base
  has_one :users
  has_many :trips
  has_many :fuel_consumptions
end
