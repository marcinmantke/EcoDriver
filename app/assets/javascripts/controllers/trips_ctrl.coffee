angular.module('EcoApp').controller 'TripsCtrl', ($scope, $http) ->
  $http.get('/mytrips.json').success (data, status, headers, config) ->
    $scope.mytrips = data
    console.log data
  $scope.map =
    center:
      latitude: 51.219053
      longitude: 4.404418
    zoom: 14
    options:
      scrollwheel: false