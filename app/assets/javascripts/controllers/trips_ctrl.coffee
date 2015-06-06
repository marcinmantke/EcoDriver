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
  $scope.circles = []
  $scope.startMarker = null
  $scope.finishMarker = null
  $scope.infoWindow = null

  $scope.labels = []
  $scope.series = ['Trip']
  $scope.data = [[]]
  $scope.options = { pointDot : false, pointHitDetectionRadius : 1 }

  icon_circle = {
    path: google.maps.SymbolPath.CIRCLE,
    fillColor: 'green',
    fillOpacity: .4,
    scale: 4.5,
    strokeColor: 'white',
    strokeWeight: 1
  }
    

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
    for circle in $scope.circles
      circle.setMap null
    $scope.circles.clear

  initPolylines = () ->
    i = 0
    while i < $scope.paths[$scope.choosenTrip].length-1
      avg_fuel_consumption = ($scope.mytrips[$scope.choosenTrip].path[i].fuel_consumption + $scope.mytrips[$scope.choosenTrip].path[i+1].fuel_consumption)/2
      if avg_fuel_consumption <= $scope.fuel_consumption_low
        color = '#00FF00'
      else if avg_fuel_consumption > $scope.fuel_consumption_low && avg_fuel_consumption <= $scope.fuel_consumption_high
        color = '#FFFF00'
      else
        color = '#FF0000'

      $scope.polylines.push initPolyline(i,i+2, color)
      initCircle(i)
      i++
    initCircle($scope.paths[$scope.choosenTrip].length-1)

  initPolyline = (start, end, color) ->
    polyline = new (google.maps.Polyline)(
      map: $scope.map
      strokeColor: color
      strokeOpacity: 1.0
      strokeWeight: 3
      path: $scope.paths[$scope.choosenTrip].slice(start, end))
    return polyline

  initCircle = (index) ->
    circle = new google.maps.Marker(
      icon: icon_circle
      position: $scope.paths[$scope.choosenTrip][index]
      map: $scope.map
      )
    google.maps.event.addListener circle, 'mouseover', ->
      if $scope.infoWindow == null
        $scope.infoWindow = new google.maps.InfoWindow({
          content: "<b>Speed</b>: #{$scope.mytrips[$scope.choosenTrip].path[index].speed} km/h<br />
          <b>RPM</b>: #{$scope.mytrips[$scope.choosenTrip].path[index].rpm}<br />
          <b>Fuel consumption</b>: #{$scope.mytrips[$scope.choosenTrip].path[index].fuel_consumption} L/100km<br />
          <b>Gear</b>: #{$scope.mytrips[$scope.choosenTrip].path[index].gear}",
          zIndex: 99999999
        })
        $scope.infoWindow.open($scope.map, circle)
    google.maps.event.addListener circle, 'mouseout', ->
      if $scope.infoWindow != null
        $scope.infoWindow.close($scope.map, circle)
        $scope.infoWindow.setMap null
        $scope.infoWindow = null
    $scope.circles.push circle

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
