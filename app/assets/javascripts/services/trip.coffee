angular.module('EcoApp').factory 'Trip', ($http) ->
  getTripsByDistance: (lower, upper) ->
    $http.post('/trips/by_distance', {lower_limit: lower, upper_limit: upper})
