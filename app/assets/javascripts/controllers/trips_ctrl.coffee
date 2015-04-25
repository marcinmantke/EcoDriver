angular.module('EcoApp').controller 'TripsCtrl', ($scope, $http) ->
  $http.get('/mytrips.json').success (data, status, headers, config) ->
    $scope.mytrips = data
    for trip in $scope.mytrips
      if trip.path.length > 0
        console.log trip.path
        trip.map =
          zoom: 18
          options:
            scrollwheel: true
          center: []
        trip.map.center.push((trip.path[0][0] + trip.path[trip.path.length-1][0])/2)
        trip.map.center.push((trip.path[0][1] + trip.path[trip.path.length-1][1])/2)
        
    console.log $scope.mytrips[15].map.center