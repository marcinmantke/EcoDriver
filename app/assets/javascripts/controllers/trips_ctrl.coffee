angular.module('EcoApp').controller 'TripsCtrl', ($scope, Trip) ->


  Trip.getMyTrips().success (data, status, headers, config) ->
    $scope.mytrips = data
    $scope.choosenTrip = $scope.mytrips[0]
    $scope.setLabels($scope.choosenTrip)
    $scope.setData($scope.choosenTrip)
    for trip in $scope.mytrips
      for point, index in trip.path
        trip.path[index] = {lat: parseFloat(point[0]), lng: parseFloat(point[1])}
    $scope.changeChoice(0)
    initMap()

  $scope.polylines = []
  $scope.circles = []
  $scope.startMarker = null
  $scope.finishMarker = null

  $scope.labels = []
  $scope.series = ['Trip']
  $scope.data = [[]]
  $scope.options = { pointDot : false, pointHitDetectionRadius : 1 }
    

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
  
    initMap()
    bounds = new google.maps.LatLngBounds
    bounds.extend (new google.maps.LatLng($scope.choosenTrip.path[0].lat, $scope.choosenTrip.path[0].lng))
    bounds.extend (new google.maps.LatLng($scope.choosenTrip.path[$scope.choosenTrip.path.length-1].lat, $scope.choosenTrip.path[$scope.choosenTrip.path.length-1].lng))
    $scope.map.fitBounds bounds
    $scope.map.setCenter($scope.choosenTrip.path[$scope.choosenTrip.path.length/2-2])

  initMap = () ->
    clearShapes()
    initPolylines()
    initMarkers()

  clearShapes = () ->
    for polyline in $scope.polylines
      polyline.setMap null
    $scope.polylines.clear
    if $scope.startMarker != null
      $scope.startMarker.setMap null
    if $scope.finishMarker != null
      $scope.finishMarker.setMap null
    for circle in $scope.circles
      circle.setMap null
    $scope.circles.clear

  initPolylines = () ->
    i = 0
    while i < $scope.choosenTrip.path.length-1
      $scope.polylines.push initPolyline(i,i+2, '#00FF00')
      i++

  initPolyline = (start, end, color) ->
    polyline = new (google.maps.Polyline)(
      map: $scope.map
      strokeColor: color
      strokeOpacity: 1.0
      strokeWeight: 3
      path: $scope.choosenTrip.path.slice(start, end))
    i = 0
    while i < polyline.getPath().getLength()
      $scope.circles.push new (google.maps.Marker)(
        icon:
          url: 'https://maps.gstatic.com/intl/en_us/mapfiles/markers2/measle_blue.png'
          size: new (google.maps.Size)(7, 7)
          anchor: new (google.maps.Point)(4, 4)
        position: polyline.getPath().getAt(i)
        map: $scope.map)
      i++
    return polyline

  initMarkers = () ->
    $scope.startMarker = new google.maps.Marker({
                map: $scope.map,
                position: $scope.choosenTrip.path[0],
                draggable: false})
    $scope.finishMarker = new google.maps.Marker({
                map: $scope.map,
                position: $scope.choosenTrip.path[$scope.choosenTrip.path.length-1],
                draggable: false})

    $scope.startInfoWindow = new google.maps.InfoWindow({
      content: "Start",
      })
    $scope.startInfoWindow.open($scope.map, $scope.startMarker)

    $scope.finishInfoWindow = new google.maps.InfoWindow({
      content: "Finish",
      })
    $scope.finishInfoWindow.open($scope.map, $scope.finishMarker)

  $scope.$on 'mapInitialized', (evt, map) ->
    $scope.map = map
