angular.module('EcoApp').controller 'DashboardCtrl', ($rootScope, $scope, $filter, Trip, Challenge, toastr) ->
  Trip.getDashboard().success (data) ->
    $scope.dashboard = data
    gage_avg_fuel = new JustGage(
      id: 'avg_fuel'
      value: $scope.dashboard.avg_fuel,
      min: 0,
      max: ($scope.dashboard.fuel_consumption.high * 1.4).toFixed(1),
      decimals: 1,
      levelColors: ["#000000"],
      label: 'l/100km',
      labelFontColor: "#000000",
      gaugeColor: '##CCFF66',
      shadowOpacity: 0)

    gage_avg_speed = new JustGage(
      id: 'avg_speed'
      value: $scope.dashboard.avg_speed
      min: 0
      max: 140
      levelColors: ["#000000"]
      labelFontColor: "#000000"
      gaugeColor: '##CCFF66'
      label: 'km/h'
      shadowOpacity = 0)

  Trip.getMyTrips().success (data) ->
    $scope.mytrips = data
    for trip in $scope.mytrips
      for point, index in trip.path
        trip.path[index] = [parseFloat(point.latitude), parseFloat(point.longitude)]

  Challenge.invitations().success (data) ->
    $scope.challenges = data  

  $scope.rejectInvitation = (challenge) ->
    Challenge.rejectInvitation(challenge.invitation_id)
    .success (data)->
      if data.success == true
        $scope.challenges.splice(challenge, 1)
        toastr.info('Invitation rejected', 'Information')
      else
        toastr.error('Please reload page and try again', 'Error')
    .error ->
      toastr.error('Please reload page and try again', 'Error')

  $scope.acceptInvitation = (challenge) ->
    Challenge.acceptInvitation(challenge.invitation_id)
    .success (data)->
      if data.success == true
        $scope.challenges.splice(challenge, 1)
        toastr.info('You joined to challenge', 'Information')
      else
        toastr.error('Please reload page and try again', 'Error')
    .error ->
      toastr.error('Please reload page and try again', 'Error')

  $scope.avgFuelCircleClass = (trip) ->
    if trip.avg_fuel <= trip.economic_ranges.fuel_consumption.low
      return 'circle_green'
    else if trip.avg_fuel > trip.economic_ranges.fuel_consumption.low && trip.avg_fuel <= trip.economic_ranges.fuel_consumption.high
      return 'circle_yellow'
    else
      return 'circle_red'

  $scope.avgSpeedCircleClass = (trip) ->
    if trip.avg_speed <= 60
      return 'circle_green'
    else if trip.avg_speed > 60 && trip.avg_speed <= 90
      return 'circle_yellow'
    else
      return 'circle_red'

  $scope.avgRPMCircleClass = (trip) ->
    if trip.avg_rpm > trip.economic_ranges.engine_type.gear_down && trip.avg_rpm <= trip.economic_ranges.engine_type.gear_up_min
      return 'circle_green'
    else if trip.avg_rpm > trip.economic_ranges.engine_type.gear_up_min && trip.avg_rpm <= trip.economic_ranges.engine_type.gear_up_max
      return 'circle_yellow'
    else
      return 'circle_red'