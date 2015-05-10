angular.module('EcoApp').controller 'DashboardCtrl', ($rootScope, $scope, Trip, Challenge) ->
  Trip.getDashboard().success (data) ->
    $scope.dashboard = data

  Trip.getMyTrips().success (data) ->
    $scope.mytrips = data

  Challenge.getChallenges().success (data) ->
    $scope.challenges = data  