angular.module('EcoApp').controller 'TripsCtrl', ($scope, Trip) ->


  Trip.getMyTrips().success (data, status, headers, config) ->
    $scope.mytrips = data
    console.log data
    $scope.choosenTrip = $scope.mytrips[0]
    for trip in $scope.mytrips
      if trip.path.length > 0
        trip.map =
          show: false
          zoom: 16


  $scope.changeChoice = (index) ->
    $scope.choosenTrip = $scope.mytrips[index]

