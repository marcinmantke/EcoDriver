require 'net/http'

class CheckPoint < ActiveRecord::Base
  belongs_to :trip

  def self.create_path(path, trip)
    api_key = 'AIzaSyDRljTMN1vNOQL2zxIMh93xA2yni1akkqU'
    points = []
    for i in 0..(path.length/100).floor
      path_temp = path[i*100..i*100+99]
      path_str = 'path='
      path_temp.each do |point|
        path_str += point[:latitude].to_s + ',' + point[:longitude].to_s
        if point != path_temp.last
          path_str  += '|'
        end
      end
      url = 'https://roads.googleapis.com/v1/snapToRoads?' + path_str + '&key=' + api_key
      logger.debug url
      result = Net::HTTP.get(URI.parse(url))       
      res_temp = ActiveSupport::JSON.decode(result)["snappedPoints"]
      points += res_temp
    end
   points.each do |point|
      CheckPoint.create(longitude: point["location"]["longitude"],
                        latitude: point["location"]["latitude"],
                        trip: trip)
    end
  end
end
