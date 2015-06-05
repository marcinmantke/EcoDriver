angular.module('EcoApp').controller 'TripsCtrl', ($scope, Trip) ->


  Trip.getMyTrips().success (data, status, headers, config) ->
    $scope.mytrips = data
    console.log data
    $scope.choosenTrip = $scope.mytrips[0]
    $scope.setLabels($scope.choosenTrip)
    $scope.setData($scope.choosenTrip)
    for trip in $scope.mytrips
      if trip.path.length > 0
        trip.map =
          show: false
          zoom: 16
    

  $scope.setLabels = (trip) ->
    i = 0
    labels = []
    while i < trip.path.length
      labels.push(i)
      i++
    $scope.labels = labels

  $scope.setData = (trip) ->
    i = 0
    data = [[]]
    while i < trip.path.length
      #console.log($scope.choosenTrip.path[i][3])
      data[0].push($scope.choosenTrip.path[i].speed)
      i++
    $scope.data = data

  $scope.changeChoice = (index) ->
    $scope.choosenTrip = $scope.mytrips[index]
    $scope.setLabels($scope.choosenTrip)
    $scope.setData($scope.choosenTrip)

  $scope.labels = []
  $scope.series = ['Trip']
  $scope.data = [[]]
  $scope.options = { pointDot : false, pointHitDetectionRadius : 1 }
