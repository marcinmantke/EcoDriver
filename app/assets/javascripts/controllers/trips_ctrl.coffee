angular.module('EcoApp').controller 'TripsCtrl', ($scope, $filter, Trip) ->

  Trip.getMyTrips().success (data, status, headers, config) ->
    $scope.mytrips = data
    console.log data
    $scope.paths = []
    for trip, index in $scope.mytrips
      $scope.paths.push []
      for point in trip.path
        $scope.paths[index].push {lat: parseFloat(point.latitude), lng: parseFloat(point.longitude)}
    initGages()
    $scope.changeChoice(0)
    initMap()
    


  $scope.polylines = []
  $scope.startMarker = null
  $scope.finishMarker = null
  $scope.infoWindow = null

  $scope.labels = []
  $scope.series = ['Speed', 'RPM', 'Fuel consumption', 'Gear']
  $scope.data = [[]]

  $scope.options = {
    bezierCurve : false,
    pointDot : false, 
    pointHitDetectionRadius : 1,
    datasetFill : false,
    scaleLabel: "<%=value%>",
    legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].strokeColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>",
    multiTooltipTemplate: (objectValue) -> 
      console.log(objectValue)
      objectValue.label = ''
      if objectValue.datasetLabel == 'Speed'
        return "Speed: " + objectValue.value*5 + " km/h"
      if objectValue.datasetLabel == 'RPM'
        return "RPM: " + objectValue.value*100
      if objectValue.datasetLabel == "Fuel consumption"
        number = $filter('number')(objectValue.value, 1)
        return "Fuel consumption: " + number + " l/100km"
      if objectValue.datasetLabel == "Gear"
        return "Gear: " + objectValue.value
  }

  $scope.optionsSpeed = { 
    pointDot : false, pointHitDetectionRadius : 1, 
    tooltipTemplate: "<%if (label){%><%=label%>: <%}%><%= value %> km/h", 
    scaleLabel: "<%=value%> km/h"
  }

  $scope.optionsRpm = { 
    pointDot : false, pointHitDetectionRadius : 1, 
    tooltipTemplate: "<%if (label){%><%=label%>: <%}%><%= value/100 %> RPM", 
    scaleLabel: "<%=value%> RPM"
  }

  $scope.optionsFuel = { 
    pointDot : false, pointHitDetectionRadius : 1, 
    tooltipTemplate: "<%if (label){%><%=label%>: <%}%><%= value %> l/100km", 
    scaleLabel: "<%=value%> l/100km"
  }

  $scope.optionsGear = { 
    pointDot : false, pointHitDetectionRadius : 1, 
    tooltipTemplate: "<%if (label){%><%=label%>: <%}%><%= value %> gear", 
    scaleLabel: "<%=value%> gear",
  }

  gage_avg_speed = null
  gage_avg_rpm = null
  gage_distance = null
  gage_avg_fuel = null
  gage_mark = null
    

  $scope.setLabels = (trip) ->
    i = 0
    labels = []
    while i < trip.path.length
      if i%(parseInt(trip.path.length/4)) == 0 || i == (trip.path.length-1)
        labels.push($filter('number')(trip.path[i].recorded_at, 2))
      else
        labels.push('')
      i++
    $scope.steps = parseInt(i/5)
    $scope.labels = labels

  $scope.setData = (trip) ->
    i = 0
    dataSpeed = [[]]
    dataRpm = [[]]
    dataFuel = [[]]
    dataGear = [[]]
    while i < trip.path.length
      dataSpeed[0].push(trip.path[i].speed/5)
      dataRpm[0].push(trip.path[i].rpm/100)
      dataFuel[0].push(trip.path[i].fuel_consumption)
      dataGear[0].push(trip.path[i].gear)
      i++
    $scope.dataSpeed = dataSpeed 
    $scope.dataRpm = dataRpm
    $scope.dataFuel = dataFuel
    $scope.dataGear = dataGear
    $scope.data[0]=dataSpeed[0]
    $scope.data[1]=dataRpm[0]
    $scope.data[2]=dataFuel[0]
    $scope.data[3]=dataGear[0]

  $scope.changeChoice = (index) ->
    $scope.choosenTrip = index
    $scope.setLabels($scope.mytrips[index])
    $scope.setData($scope.mytrips[index])
    if $scope.data[0].length <= 50
      $scope.pointHitDetectionRadius = 10
    else
      $scope.pointHitDetectionRadius = 1

  
    Trip.getFuelConsumptionIntervals($scope.mytrips[index].engine_type_id,
      $scope.mytrips[index].engine_displacement_id).success (data) ->
        $scope.fuel_consumption_low = data.data.fuel_consumption.low
        $scope.fuel_consumption_high = data.data.fuel_consumption.high
        $scope.gear_down = data.data.engine_type.gear_down
        $scope.gear_up_min = data.data.engine_type.gear_up_min
        $scope.gear_up_max = data.data.engine_type.gear_up_max
        initMap()
        bounds = new google.maps.LatLngBounds
        bounds.extend (new google.maps.LatLng($scope.paths[$scope.choosenTrip][0].lat, $scope.paths[$scope.choosenTrip][0].lng))
        bounds.extend (new google.maps.LatLng($scope.paths[$scope.choosenTrip][$scope.paths[$scope.choosenTrip].length-1].lat, $scope.paths[$scope.choosenTrip][$scope.paths[$scope.choosenTrip].length-1].lng))
        $scope.map.fitBounds bounds
        updateGages()

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
          position: event.latLng
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


  initGages = () ->
    gage_avg_speed = new JustGage(
      id: 'avg_speed'
      value: 0
      min: 0
      max: 140
      customSectors: [
        {
            color: "#00FF00",
            lo: 0,
            hi: 70
        },
        {
            color: "#FFFF00",
            lo: 70,
            hi: 100
        },
        {
            color: "#FF0000",
            lo: 100,
            hi: 140
        }
      ]
      title: 'Average speed'
      label: 'km/h'
      titleMinFontSize: 14
      showInnerShadow: true
      shadowOpacity = 0.5
      shadowSize = 3
      shadowVerticalOffset = 10)

    Trip.getDashboard().success (data) ->
      console.log data
      gage_distance = new JustGage(
        id: 'distance'
        value: $scope.mytrips[0].distance
        min: 0
        max: (data.mileage/data.trips_number).toFixed(2)
        decimals: 2
        levelColors: ["#3175C1"]
        title: 'Distance'
        label: 'km'
        titleMinFontSize: 14
        showInnerShadow: true
        shadowOpacity = 0.5
        shadowSize = 3
        shadowVerticalOffset = 10)

    gage_mark = new JustGage(
      id: 'mark'
      value: $scope.mytrips[0].mark
      min: 0.0
      max: 10.0
      decimals: 1
      levelColors: ["#FF0000", "#FF3232", "#FFFF4C", "#FFFF00", "#00FF00"]
      title: 'Eco mark'
      titleMinFontSize: 14
      showInnerShadow: true
      shadowOpacity = 0.5
      shadowSize = 3
      shadowVerticalOffset = 10)

  remove = (id) ->
    document.getElementById(id).children[0].remove()


  updateGages = () ->
    remove('avg_fuel') if gage_avg_fuel != null
    remove('avg_rpm') if gage_avg_rpm != null

    gage_avg_speed.refresh($scope.mytrips[$scope.choosenTrip].avg_speed)
    gage_distance.refresh($scope.mytrips[$scope.choosenTrip].distance)
    gage_mark.refresh($scope.mytrips[$scope.choosenTrip].mark)

    gage_avg_fuel = new JustGage(
      id: 'avg_fuel'
      value: $scope.mytrips[$scope.choosenTrip].avg_fuel
      min: 0
      max: ($scope.fuel_consumption_high * 1.4).toFixed(1)
      decimals: 1
      customSectors: [
        {
            color: "#00FF00",
            lo: 0,
            hi: $scope.fuel_consumption_low
        },
        {
            color: "#FFFF00",
            lo: $scope.fuel_consumption_low,
            hi: $scope.fuel_consumption_high
        },
        {
            color: "#FF0000",
            lo: $scope.fuel_consumption_high,
            hi: ($scope.fuel_consumption_high * 1.4)
        }
      ]
      noGradient: true
      title: 'Average fuel consumption'
      label: 'l/100km'
      titleMinFontSize: 14
      showInnerShadow: true
      shadowOpacity = 0.5
      shadowSize = 3
      shadowVerticalOffset = 10)

    gage_avg_rpm = new JustGage(
      id: 'avg_rpm'
      value: $scope.mytrips[$scope.choosenTrip].avg_rpm
      min: 0
      max: 5000
      customSectors: [
        {
            color: "#FF0000",
            lo: 0,
            hi: $scope.gear_down*0.6
        },
        {
            color: "#FFFF00",
            lo: $scope.gear_down*0.6
            hi: $scope.gear_down*0.8
        },
        {
            color: "#FFFF4C",
            lo: $scope.gear_down*0.8
            hi: $scope.gear_down*0.9
        },
        {
            color: "#00FF00",
            lo: $scope.gear_down*0.9,
            hi: $scope.gear_up_min
        },
        {
            color: "#FFFF4C",
            lo: $scope.gear_up_min,
            hi: $scope.gear_up_max*1.3
        },
        {
            color: "#FF0000",
            lo: $scope.gear_up_max*1.3,
            hi: 5000
        }
      ]
      noGradient: false
      title: 'Average RPM'
      label: 'rpm'
      titleMinFontSize: 14
      showInnerShadow: true
      shadowOpacity = 0.5
      shadowSize = 3
      shadowVerticalOffset = 10)
  
  $scope.chartObject =
    'type': 'AreaChart'
    'displayed': true
    'data':
      'cols': [
        {
          'id': 'month'
          'label': 'Month'
          'type': 'string'
          'p': {}
        }
        {
          'id': 'laptop-id'
          'label': 'Laptop'
          'type': 'number'
          'p': {}
        }
        {
          'id': 'desktop-id'
          'label': 'Desktop'
          'type': 'number'
          'p': {}
        }
        {
          'id': 'server-id'
          'label': 'Server'
          'type': 'number'
          'p': {}
        }
        {
          'id': 'cost-id'
          'label': 'Shipping'
          'type': 'number'
        }
      ]
      'rows': [
        { 'c': [
          { 'v': 'January' }
          {
            'v': 19
            'f': '42 items'
          }
          {
            'v': 12
            'f': 'Ony 12 items'
          }
          {
            'v': 7
            'f': '7 servers'
          }
          { 'v': 4 }
        ] }
        { 'c': [
          { 'v': 'February' }
          { 'v': 13 }
          {
            'v': 1
            'f': '1 unit (Out of stock this month)'
          }
          { 'v': 12 }
          { 'v': 2 }
        ] }
        { 'c': [
          { 'v': 'March' }
          { 'v': 24 }
          { 'v': 5 }
          { 'v': 11 }
          { 'v': 6 }
        ] }
      ]
    'options':
      'title': 'Sales per month'
      'isStacked': 'true'
      'fill': 20
      'displayExactValues': true
      'vAxis':
        'title': 'Sales unit'
        'gridlines': 'count': 10
      'hAxis': 'title': 'Date'
    'formatters': {}
