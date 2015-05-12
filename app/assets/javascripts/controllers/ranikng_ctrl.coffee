angular.module('EcoApp').controller 'RankingCtrl', ($http, $scope, Trip)->
  $scope.radioModel = '0-10'

  $scope.getTripsByDistance = ()->
    limits = $scope.radioModel.split("-")
    Trip.getTripsByDistance(limits[0], limits[1]).success (data)->
      $scope.trips_by_distance = data

  $scope.getTripsByDistance()

  $scope.radioModelDisplacement = '<1.0'
  $scope.radioModelFuel = 'petrol'

  $scope.getTripsByEngineType = ()->
    Trip.getTripsByEngineType($scope.radioModelFuel, $scope.radioModelDisplacement).success (data)->
      $scope.trips_by_engine_type = data

  $scope.getTripsByEngineType()
