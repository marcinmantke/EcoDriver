angular.module('EcoApp').controller 'RankingCtrl', ($http, $scope, Trip)->
  $scope.limits
  $scope.radioModel = null

  $scope.getTripsByDistance = ()->
    if $scope.radioModel != null
      limits = $scope.radioModel.split("-")
      Trip.getTripsByDistance(limits[0], limits[1]).success (data)->
        $scope.tripsByDistance = data
    else
      Trip.getTripsByDistance(null, null).success (data)->
        $scope.tripsByDistance = data

  $scope.getTripsByDistance()

  $scope.getTripsByEngineType = ()->
    Trip.getTripsByEngineType($scope.radioModelFuel, $scope.radioModelDisplacement)
    .success (data)->
      $scope.tripsByType = data
      console.log(data)

  $scope.getTripsByEngineType()
