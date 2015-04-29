angular.module('EcoApp').controller 'ChallengesCtrl', ($scope, $http, $modal, $interval, $timeout, Trip) ->
  Trip.getMyTrips().success (data)->
    $scope.trips = data
    $scope.challenges = data
    console.log data
    $scope.choosenTrip = $scope.trips[0]
    $scope.trips[1].path[0]= [51.11183649, 17.05963249]

  $scope.changeChoice = (index) ->
    $scope.choosenTrip = $scope.trips[index]

   $scope.calendar =
    opened: false
    date: null
    dateOptions:
      formatYear: "yy"
      startingDay: 1
    format: "dd-MM-yyyy"

    toggleMin: ->
      $scope.calendar.minDate = new Date()
      @date = $scope.calendar.minDate

    open: (e) ->
      e.preventDefault()
      e.stopPropagation()
      @opened = true

  $scope.calendar.toggleMin()

  $scope.saveChallenge = () ->
    $scope.challenges.unshift($scope.choosenTrip)
    console.log $scope.challenges
    $scope.createView = false
