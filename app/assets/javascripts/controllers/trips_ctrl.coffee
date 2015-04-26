angular.module('EcoApp').controller 'TripsCtrl', ($scope, $http, $location, $anchorScroll) ->
  $http.get('/mytrips.json').success (data, status, headers, config) ->
    $scope.mytrips = data
    for trip in $scope.mytrips
      if trip.path.length > 0
        trip.map =
          show: false
          zoom: 16

