# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

angular.module('EcoApp').controller 'TripsCtrl', ($http, $scope, Trip)->
    $scope.test = "gdfgh"

    Trip.getTripsByDistance(0, 1000).success (data)->
    	console.log(data)
    	$scope.trips_by_distance = data

.controller 'MyTripsCtrl', ($scope, $http) ->
  $http.get('/mytrips.json').success((data, status, headers, config) ->
    $scope.mytrips = data
    return
  ).error (data, status, headers, config) ->
    # log error
    return
  return