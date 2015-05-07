angular.module('EcoApp').controller 'DashboardCtrl', ($rootScope, $scope, Trip) ->
  $scope.test = false
  Trip.getDashboard().success (data, status, headers, config) ->
    $scope.dashboard = data
