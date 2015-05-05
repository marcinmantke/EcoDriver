angular.module('EcoApp').factory 'Challenge', ($http) ->
  createChallenge: (trip_id, finish_date) ->
    $http.post('/challenge/create.json', {trip_id: trip_id, finish_date: finish_date})

  getChallenges: () ->
    $http.get('/challenge/all.json')