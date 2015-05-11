angular.module('EcoApp').controller 'ChallengesCtrl', ($scope, $http, $modal, $interval, $timeout, Trip, Challenge) ->
  Trip.getMyTrips().success (data)->
    $scope.trips = data
    $scope.choosenTrip = $scope.trips[0]

  Challenge.getChallenges().success (data) ->
    $scope.challenges = data
    $scope.choosenChallenge = $scope.challenges[0]
  .error (data) ->
      console.log(data)


  $scope.changeChoice = (index) ->
    $scope.choosenTrip = $scope.trips[index]

  $scope.changeChoiceChallenge = (index) ->
    $scope.choosenChallenge = $scope.challenges[index]
    $scope.challengeList = !$scope.challengeList
    console.log $scope.choosenChallenge.id
    Challenge.getChallengeTrips($scope.choosenChallenge.id).success (data) ->
      $scope.challengeTrips = data.trips
      $scope.challengePath = data.path

  $scope.calendar =
    opened: false
    date: null
    dateOptions:
      formatYear: "yy"
      startingDay: 1
    format: "dd-MM-yyyy"

    toggleMin: ->
      $scope.calendar.minDate = new Date()
      $scope.calendar.minDate.setDate($scope.calendar.minDate.getDate()+7)
      @date = $scope.calendar.minDate

    open: (e) ->
      e.preventDefault()
      e.stopPropagation()
      @opened = true

  $scope.calendar.toggleMin()

  $scope.saveChallenge = () ->
    Challenge.createChallenge($scope.choosenTrip.id, $scope.calendar.date).success (data) ->
      if data.success
        $scope.challenges.unshift(data.data)
      $scope.createView = false

  $scope.joinChallenge = () ->
    Challenge.joinChallenge($scope.choosenChallenge.id).success (data) ->
      console.log("Success")
    .error (data) ->
      console.log(data)

  $scope.challengeList = true
