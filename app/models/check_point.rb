require 'net/http'

class CheckPoint < ActiveRecord::Base
  belongs_to :trip

  def self.create_path(path, trip)
    points = []
    (0..(path.length / 100).floor).each do |i|
      path_temp = path[i * 100..i * 100 + 99]
      res_temp = CheckPoint.points_from_api(path_temp)
      points += res_temp
    end
    CheckPoint.save_checkpoints(points, trip)
  end

  def self.points_from_api(path)
    path_str = 'path='
    path.each do |point|
      path_str += point[:latitude].to_s + ',' + point[:longitude].to_s
      path_str += '|' if point != path.last
    end
    res_temp = CheckPoint.get_from_api(path_str)
    res_temp
  end

  def self.get_from_api(path_str)
    api_key = 'AIzaSyDRljTMN1vNOQL2zxIMh93xA2yni1akkqU'
    url = 'https://roads.googleapis.com/v1/snapToRoads?'
    url += path_str + '&key=' + api_key
    result = CheckPoint.make_https_query(url)
    res_temp = ActiveSupport::JSON.decode(result.body)['snappedPoints']
    res_temp
  end

  def self.make_https_query(url)
    encoded_url = URI.encode(url)
    parsed_url = URI.parse(encoded_url)
    http = Net::HTTP.new(parsed_url.host, parsed_url.port)
    http.use_ssl = true
    result = http.get(parsed_url.request_uri)
    result
  end

  def self.save_checkpoints(points, trip)
    points.each do |point|
      CheckPoint.create(longitude: point['location']['longitude'],
                        latitude: point['location']['latitude'],
                        trip: trip)
    end
  end
end
