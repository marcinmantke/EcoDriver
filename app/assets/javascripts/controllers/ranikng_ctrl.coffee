angular.module('EcoApp').controller 'RankingCtrl', ($http, $scope, Trip)->
  $scope.limits = []
  $scope.limits[0] = null
  $scope.limits[1] = null
  $scope.engineDisplacement = null
  $scope.engineType = null

  Trip.getGearParams().success (data) ->
    $scope.engineDisplacements = data.displacements
    $scope.engineTypes = data.types

  $scope.getRankingTrips = ()->
    Trip.ranking($scope.engineType, $scope.engineDisplacement, $scope.limits[0], $scope.limits[1]).success (data)->
      $scope.trips = data
      console.log data

  $scope.setDistanceRange = (distanceRange) ->
    $scope.distanceRange = distanceRange
    $scope.limits = distanceRange.split("-")
    $scope.getRankingTrips()

  $scope.setEngineType = (engineType) ->
    $scope.engineType = engineType
    $scope.getRankingTrips()

  $scope.setEngineDisplacement = (engineDisplacement) ->
    $scope.engineDisplacement = engineDisplacement
    $scope.getRankingTrips()



  $scope.distanceRanges = [
    { display: '0 - 100 km', value: '0-100' },
    { display: '100 - 500 km', value: '100-500' },
    { display: '500 - 2 000 km', value: '500-2000' },
    { display: '2 000 - 10 000 km', value: '2000-10000' },
    { display: '10 000 - 20 000 km', value: '10000-20000' },
    { display: 'more than 20 000 km', value: '20000-999999999999' }
  ]

  $scope.getRankingTrips()