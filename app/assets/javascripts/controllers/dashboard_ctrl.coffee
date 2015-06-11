angular.module('EcoApp').controller 'DashboardCtrl', ($rootScope, $scope, $filter, Trip, Challenge, toastr) ->
  Trip.getDashboard().success (data) ->
    $scope.dashboard = data
    gage_avg_fuel = new JustGage(
      id: 'avg_fuel'
      value: $scope.dashboard .avg_fuel,
      min: 0,
      max: ($scope.dashboard.fuel_consumption.high * 1.4).toFixed(1),
      decimals: 1,
      levelColors: ["#333333"],
      label: 'l/100km',
      labelFontColor: "#333333",
      gaugeColor: '#5cb85c',
      shadowOpacity: 0)

    gage_avg_speed = new JustGage(
      id: 'avg_speed'
      value: $scope.dashboard.avg_speed
      min: 0
      max: 140
      levelColors: ["#333333"]
      labelFontColor: "#333333"
      gaugeColor: '#5cb85c'
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
      console.log data
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
      console.log data
      if data.success == true
        $scope.challenges.splice(challenge, 1)
        toastr.info('You joined to challenge', 'Information')
      else
        toastr.error('Please reload page and try again', 'Error')
    .error ->
      toastr.error('Please reload page and try again', 'Error')