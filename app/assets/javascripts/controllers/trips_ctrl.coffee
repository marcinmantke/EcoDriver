angular.module('EcoApp').controller 'TripsCtrl', ($scope, Trip) ->
  Trip.getMyTrips().success (data, status, headers, config) ->
    $scope.mytrips = data
    for trip in $scope.mytrips
      if trip.path.length > 0
        trip.map =
          show: false
          zoom: 16

