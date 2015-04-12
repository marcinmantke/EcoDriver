# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

angular.module('EcoApp').controller 'TripsCtrl', ($http, $scope, Trip)->
  $scope.test = "gdfgh"

  $scope.radioModel = '0-10'

  $scope.getTripsByDistance = ()->
    limits = $scope.radioModel.split("-")
    console.log limits
    Trip.getTripsByDistance(limits[0], limits[1]).success (data)->
      $scope.trips_by_distance = data

  $scope.getTripsByDistance()

  $scope.radioModelDisplacement = '<1.0'
  $scope.radioModelFuel = 'petrol'

  $scope.getTripsByEngineType = ()->
    console.log $scope.radioModelDisplacement
    console.log $scope.radioModelFuel
    Trip.getTripsByEngineType($scope.radioModelFuel, $scope.radioModelDisplacement).success (data)->
      $scope.trips_by_engine_type = data

  $scope.getTripsByEngineType()

.controller 'MyTripsCtrl', ($scope, $http) ->
  $http.get('/mytrips.json').success((data, status, headers, config) ->
    $scope.mytrips = data
    return
  ).error (data, status, headers, config) ->
    # log error
    return
  return


.controller 'NavbarIsActive', ($scope, $location) ->

  $scope.isActive = (route) ->
    route == $location.path()

  return