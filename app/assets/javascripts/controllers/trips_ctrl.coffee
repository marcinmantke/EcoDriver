angular.module('EcoApp').controller 'TripsCtrl', ($scope, $http) ->
  $http.get('/mytrips.json').success (data, status, headers, config) ->
    $scope.mytrips = data
    console.log data
