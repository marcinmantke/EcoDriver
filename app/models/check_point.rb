class CheckPoint < ActiveRecord::Base
  belongs_to :trip

  def self.create_path(path, trip)
    path.each do |point|
      CheckPoint.create(longitude: point[:longitude],
                        latitude: point[:latitude],
                        trip: trip)
    end
  end
end
