angular.module('EcoApp').controller 'TripsCtrl', ($scope, Trip) ->


  Trip.getMyTrips().success (data, status, headers, config) ->
    $scope.mytrips = data
    console.log data
    $scope.paths = []
    for trip, index in $scope.mytrips
      $scope.paths.push []
      for point in trip.path
        $scope.paths[index].push {lat: parseFloat(point.latitude), lng: parseFloat(point.longitude)}
    $scope.changeChoice(0)
    initMap()


  $scope.polylines = []
  $scope.startMarker = null
  $scope.finishMarker = null
  $scope.infoWindow = null

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
    data = []
    data.push []
    while i < trip.path.length
      #console.log($scope.paths[$scope.choosenTrip][i][3])
      data[0].push($scope.mytrips[$scope.choosenTrip].path[i].speed)
      i++
    $scope.data = data 

  $scope.changeChoice = (index) ->
    $scope.choosenTrip = index
    $scope.setLabels($scope.mytrips[index])
    $scope.setData($scope.mytrips[index])
  
    Trip.getFuelConsumptionIntervals($scope.mytrips[index].engine_type_id,
      $scope.mytrips[index].engine_displacement_id).success (data) ->
        $scope.fuel_consumption_low = data.data.low
        $scope.fuel_consumption_high = data.data.high
        initMap()
        bounds = new google.maps.LatLngBounds
        bounds.extend (new google.maps.LatLng($scope.paths[$scope.choosenTrip][0].lat, $scope.paths[$scope.choosenTrip][0].lng))
        bounds.extend (new google.maps.LatLng($scope.paths[$scope.choosenTrip][$scope.paths[$scope.choosenTrip].length-1].lat, $scope.paths[$scope.choosenTrip][$scope.paths[$scope.choosenTrip].length-1].lng))
        $scope.map.fitBounds bounds

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

  initPolylines = () ->
    i = 0
    while i < $scope.paths[$scope.choosenTrip].length-1
      fuel_consumption = $scope.mytrips[$scope.choosenTrip].path[i].fuel_consumption
      if fuel_consumption <= $scope.fuel_consumption_low
        color = '#00FF00'
      else if fuel_consumption > $scope.fuel_consumption_low && fuel_consumption <= $scope.fuel_consumption_high
        color = '#FFFF00'
      else
        color = '#FF0000'

      $scope.polylines.push initPolyline(i,i+2, color)
      i++

  initPolyline = (start, end, color) ->
    polyline = new (google.maps.Polyline)(
      map: $scope.map
      strokeColor: color
      strokeOpacity: 0.7
      strokeWeight: 4
      path: $scope.paths[$scope.choosenTrip].slice(start, end))
    google.maps.event.addListener polyline, 'mouseover', (event)->
      if $scope.infoWindow == null
        $scope.infoWindow = new google.maps.InfoWindow({
          content: "<b>Speed</b>: #{$scope.mytrips[$scope.choosenTrip].path[start].speed} km/h<br />
          <b>RPM</b>: #{$scope.mytrips[$scope.choosenTrip].path[start].rpm}<br />
          <b>Fuel consumption</b>: #{$scope.mytrips[$scope.choosenTrip].path[start].fuel_consumption} L/100km<br />
          <b>Gear</b>: #{$scope.mytrips[$scope.choosenTrip].path[start].gear}",
          position: event.latLng,
          disableAutoPan: true
        })
        $scope.infoWindow.open($scope.map)
    google.maps.event.addListener polyline, 'mouseout', ->
      sleep(200)
      if $scope.infoWindow != null
        $scope.infoWindow.close()
        $scope.infoWindow.setMap null
        $scope.infoWindow = null
    return polyline

  initMarkers = () ->
    $scope.startMarker = new google.maps.Marker({
                map: $scope.map,
                position: $scope.paths[$scope.choosenTrip][0],
                draggable: false,
                zIndex: 0,
                disableAutoPan: true,
                icon : new google.maps.MarkerImage('/assets/start.png')})
    $scope.finishMarker = new google.maps.Marker({
                map: $scope.map,
                position: $scope.paths[$scope.choosenTrip][$scope.paths[$scope.choosenTrip].length-1],
                draggable: false,
                zIndex: 0,
                disableAutoPan: true,
                icon : new google.maps.MarkerImage('/assets/finish.png')})

  $scope.$on 'mapInitialized', (evt, map) ->
    $scope.map = map

  sleep = (ms) ->
    start = new Date().getTime()
    continue while new Date().getTime() - start < ms
