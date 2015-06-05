angular.module('EcoApp').controller 'ChallengesCtrl', ($scope, $http, $modal, $interval, $timeout, $compile, toastr, Trip, Challenge) ->
  Trip.getMyTrips().success (data)->
    $scope.trips = []
    for trip in data
      if trip.challenge == null
        $scope.trips.push trip
      for point, index in trip.path
        trip.path[index] = {lat: parseFloat(point.latitude), lng: parseFloat(point.longitude)}  

  Challenge.getChallenges().success (data) ->
    $scope.challenges = data
    $scope.choosenChallenge = $scope.challenges[0]

  Trip.getGearParams().success (data) ->
    $scope.engineDisplacements = data.displacements
    $scope.engineTypes = data.types

  $scope.startPoly = null
  $scope.circles = []
  $scope.endPoly = null
  $scope.challengePoly = null
  $scope.startMarker = null
  $scope.finishMarker = null
  $scope.createView = false
  $scope.startIndex = 1
  $scope.endIndex = 2

  icon_circle = {
    path: google.maps.SymbolPath.CIRCLE,
    fillColor: 'green',
    fillOpacity: .4,
    scale: 4.5,
    strokeColor: 'white',
    strokeWeight: 1
  }

  initMap = () ->
    clearShapes()
    initPolylines()
    initMarkers()

    $scope.startPoly.setMap $scope.map
    $scope.endPoly.setMap $scope.map
    $scope.challengePoly.setMap $scope.map

  clearShapes = () ->
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
    for circle in $scope.circles
      circle.setMap null
    $scope.circles.clear

  initPolylines = () ->
    if $scope.startIndex < $scope.endIndex
      start = $scope.startIndex
      end = $scope.endIndex
    else
      end = $scope.startIndex
      start = $scope.endIndex
    $scope.startPoly = initPolyline(0,start+1, '#00FF00')
    $scope.endPoly = initPolyline(end, $scope.choosenTrip.path.length, '#00FF00')
    $scope.challengePoly = initPolyline(start, end+1, '#FF0000')

  initPolyline = (start, end, color) ->
    polyline = new (google.maps.Polyline)(
      strokeColor: color
      strokeOpacity: 1.0
      strokeWeight: 3
      path: $scope.choosenTrip.path.slice(start, end))
    i = 0
    while i < polyline.getPath().getLength()
      $scope.circles.push new (google.maps.Marker)(
        icon: icon_circle
        position: polyline.getPath().getAt(i)
        map: $scope.map)
      i++
    return polyline

  initMarkers = () ->
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

  $scope.getTripsByEngineType = (engineType, engineDisplacement)->
    Challenge.getChallengeTrips($scope.choosenChallenge.id, engineType, engineDisplacement).success (data) ->
        $scope.challengeTrips = data.trips
        $scope.challengePath = []
        for point in data.path
          formatted_point = []
          formatted_point.push parseFloat(point.latitude)
          formatted_point.push parseFloat(point.longitude)
          $scope.challengePath.push formatted_point


  $scope.changeChoice = (index) ->
    $scope.choosenTrip = $scope.trips[index]
    $scope.startIndex = 1
    $scope.endIndex = 2
    initMap()
    bounds = new (google.maps.LatLngBounds)
    bounds.extend (new google.maps.LatLng($scope.choosenTrip.path[0].lat, $scope.choosenTrip.path[0].lng))
    bounds.extend (new google.maps.LatLng($scope.choosenTrip.path[$scope.choosenTrip.path.length-1].lat, $scope.choosenTrip.path[$scope.choosenTrip.path.length-1].lng))
    $scope.map.fitBounds bounds
    
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
    Challenge.createChallenge($scope.choosenTrip.id, $scope.calendar.date, $scope.startIndex, $scope.endIndex).success (data) ->
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
    pi = Math.PI
    R = 6371
    distances = []
    closest = -1
    i = 0
    lat1 = event.latLng.lat()
    lng1 = event.latLng.lng()
    while i < $scope.choosenTrip.path.length
      lat2 = $scope.choosenTrip.path[i].lat
      lng2 = $scope.choosenTrip.path[i].lng
      chLat = lat2 - lat1
      chLng = lng2 - lng1
      dLat = chLat * pi / 180
      dLng = chLng * pi / 180
      rLat1 = lat1 * pi / 180
      rLat2 = lat2 * pi / 180
      a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.sin(dLng / 2) * Math.sin(dLng / 2) * Math.cos(rLat1) * Math.cos(rLat2)
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
      d = R * c
      distances[i] = d
      if closest == -1 or d < distances[closest]
        closest = i
      i++
    if distances[closest] < 0.02
      if isStartMarker && $scope.endIndex != closest
        $scope.startIndex = closest
      else if !isStartMarker && $scope.startIndex != closest
        $scope.endIndex = closest
    initMap()

  $scope.$on 'mapInitialized', (evt, map) ->
    $scope.map = map
    if $scope.createView == true
      $scope.changeChoice(0)
      initMap()
