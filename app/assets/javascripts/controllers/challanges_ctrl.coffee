angular.module('EcoApp').controller 'ChallengesCtrl', ($scope, $http, $modal, $interval, $timeout, $compile, toastr, Trip, Challenge) ->
  Trip.getMyTrips().success (data)->
    $scope.trips = []
    for trip in data
      if trip.challenge == null
        $scope.trips.push trip
      for point, index in trip.path
        trip.path[index] = {lat: parseFloat(point[0]), lng: parseFloat(point[1])}
    $scope.choosenTrip = $scope.trips[0]
    

  Challenge.getChallenges().success (data) ->
    $scope.challenges = data
    $scope.choosenChallenge = $scope.challenges[0]

  Trip.getGearParams().success (data) ->
    $scope.engineDisplacements = data.displacements
    $scope.engineTypes = data.types

  $scope.startPoly = null
  $scope.endPoly = null
  $scope.challengePoly = null
  $scope.startMarker = null
  $scope.finishMarker = null
  $scope.createView = false
  $scope.startIndex = 1
  $scope.endIndex = 2


  initMap = () ->
    if $scope.startPoly != null
      $scope.startPoly.setMap null
    if $scope.endPoly != null
      $scope.endPoly.setMap null
    if $scope.challengePoly != null
      $scope.challengePoly.setMap null
    if $scope.startMarker != null
      $scope.startMarker.setMap null
    if $scope.finishMarker != null
      $scope.finishMarker.setMap null
    $scope.startPoly = new (google.maps.Polyline)(
      strokeColor: '#00FF00'
      strokeOpacity: 1.0
      strokeWeight: 3
      path: $scope.choosenTrip.path.slice(0,$scope.startIndex+1))
    $scope.endPoly = new (google.maps.Polyline)(
      strokeColor: '#00FF00'
      strokeOpacity: 1.0
      strokeWeight: 3
      path: $scope.choosenTrip.path.slice($scope.endIndex, $scope.choosenTrip.path.length))
    $scope.challengePoly = new (google.maps.Polyline)(
      strokeColor: '#FF0000'
      strokeOpacity: 1.0
      strokeWeight: 3
      path: $scope.choosenTrip.path.slice($scope.startIndex,$scope.endIndex+1))

    $scope.startMarker = new google.maps.Marker({
                map: $scope.map,
                position: $scope.choosenTrip.path[$scope.startIndex],
                draggable: true})
    $scope.finishMarker = new google.maps.Marker({
                map: $scope.map,
                position: $scope.choosenTrip.path[$scope.endIndex],
                draggable: true})

    google.maps.event.addListener $scope.startMarker, 'dragend', (event) ->
      $scope.updateMarker(event, true)

    google.maps.event.addListener $scope.finishMarker, 'dragend', (event) ->
      $scope.updateMarker(event, false)

    $scope.startInfoWindow = new google.maps.InfoWindow({
      content: "Start",
      })
    $scope.startInfoWindow.open($scope.map, $scope.startMarker)

    $scope.finishInfoWindow = new google.maps.InfoWindow({
      content: "Finish",
      })
    $scope.finishInfoWindow.open($scope.map, $scope.finishMarker)

    $scope.startPoly.setMap $scope.map
    $scope.endPoly.setMap $scope.map
    $scope.challengePoly.setMap $scope.map
    $scope.map.setCenter $scope.choosenTrip.path[0]
    $scope.map.setZoom 16

  $scope.getTripsByEngineType = (engineType, engineDisplacement)->
    Challenge.getChallengeTrips($scope.choosenChallenge.id, engineType, engineDisplacement).success (data) ->
        $scope.challengeTrips = data.trips
        $scope.challengePath = data.path


  $scope.changeChoice = (index) ->
    $scope.choosenTrip = $scope.trips[index]
    $scope.startIndex = 1
    $scope.endIndex = 2
    initMap()
    
  $scope.changeChoiceChallenge = (index) ->
    $scope.choosenChallenge = $scope.challenges[index]
    $scope.challengeList = !$scope.challengeList
    $scope.getTripsByEngineType(null, null)


    

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
        $scope.trips.splice($scope.choosenTrip, 1)
        toastr.success('Challenge created', 'Success')
      else
        toastr.error('Please reload page and try again', 'Error')

  $scope.joinChallenge = () ->
    Challenge.joinChallenge($scope.choosenChallenge.id).success (data) ->
      if(data.success)
        $scope.choosenChallenge.is_joined = 1
        toastr.success('You joined to challenge', 'Success')
      else
        toastr.error('You already have joined to this challenge', 'Error')
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
      if data == "true"
        toastr.success("Invitation has been sent", 'Success')
      else
        toastr.error("You have already invited " + $scope.user, 'Error')

  $scope.updateMarker = (event, isStartMarker) ->
    index = 0
    while(index < $scope.choosenTrip.path.length - 1)
      if google.maps.geometry.poly.isLocationOnEdge(event.latLng,
        new (google.maps.Polyline)(
          path: $scope.choosenTrip.path.slice(index,index+2)), 0.001)
        if isStartMarker
          $scope.startIndex = index
        else
          $scope.endIndex = index+1
        break
      else
        index += 1
    initMap()

  $scope.$on 'mapInitialized', (evt, map) ->
    $scope.map = map
    if $scope.createView == true
      initMap()
      console.log "asd"
