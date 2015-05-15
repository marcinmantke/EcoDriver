angular.module('EcoApp').factory 'Trip', ($http) ->
  getTripsByDistance: (lower, upper) ->
    $http.post('/trips/by_distance.json', {lower_limit: lower, upper_limit: upper})

  getTripsByEngineType: (engine_type, engine_displacement) ->
    $http.post('/trips/by_car_type.json', {engine_type: engine_type, engine_displacement: engine_displacement})

  getMyTrips: () ->
    $http.get('/mytrips.json')

  getDashboard: () ->
    $http.get('/dashboard.json')
