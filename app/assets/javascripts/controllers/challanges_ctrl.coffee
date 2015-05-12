angular.module('EcoApp').controller 'ChallengesCtrl', ($scope, $http, $modal, $interval, $timeout, $compile, toastr, Trip, Challenge) ->
  Trip.getMyTrips().success (data)->
    $scope.trips = data
    $scope.choosenTrip = $scope.trips[0]

  Challenge.getChallenges().success (data) ->
    $scope.challenges = data
    $scope.choosenChallenge = $scope.challenges[0]
  .error (data) ->
      console.log(data)

  $scope.radioModelDisplacement = '<1.0'
  $scope.radioModelFuel = 'petrol'

  $scope.getTripsByEngineType = ()->
    Challenge.getChallengeTrips($scope.choosenChallenge.id, $scope.radioModelFuel, $scope.radioModelDisplacement).success (data) ->
        $scope.challengeTrips = data.trips
        $scope.challengePath = data.path


  $scope.changeChoice = (index) ->
    $scope.choosenTrip = $scope.trips[index]

  $scope.changeChoiceChallenge = (index) ->
    $scope.choosenChallenge = $scope.challenges[index]
    $scope.challengeList = !$scope.challengeList
    $scope.getTripsByEngineType()
    

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
      toastr.success('You joined to challenge', 'Success')
    .error (data) ->
      toastr.error('Please reload page and try again', 'Error')

  $scope.challengeList = true

  $scope.autocompleteOption =
    options:
      html: true
      focusOpen: false
      onlySelectValid: true
      source: (request, response) ->
        Challenge.getAllUsers().success (users) ->
          data = []
          for user in users
            data.push user.username
          data = $scope.autocompleteOption.methods.filter(data, request.term)
          if !data.length
            data.push
              label: 'not found'
              value: ''
          response data
    methods: {}

  $scope.inviteUser = () ->
    Challenge.inviteUser($scope.user, $scope.choosenChallenge.id).success (data) ->
      console.log data
      if data.success
        toastr.success(data.msg, 'Success')
      else
        toastr.error(data.msg, 'Error')
