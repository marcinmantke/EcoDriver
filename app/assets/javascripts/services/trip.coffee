angular.module('EcoApp').factory 'Trip', ($http) ->

  getGearParams: () ->
    $http.get('/android/engine_params.json')

  ranking: (engine_type, engine_displacement, lower, upper) ->
    $http.post('/trips/ranking.json', {engine_type: engine_type, engine_displacement: engine_displacement, lower_limit: lower, upper_limit: upper})

  getMyTrips: () ->
    $http.get('/mytrips.json')

  getDashboard: () ->
    $http.get('/dashboard.json')

  getFuelConsumptionIntervals: (engine_type, engine_displacement) ->
    $http.post('/economic_ranges.json', {eng_type: engine_type, eng_disp: engine_displacement})
