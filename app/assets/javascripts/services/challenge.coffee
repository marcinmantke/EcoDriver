angular.module('EcoApp').factory 'Challenge', ($http) ->
  createChallenge: (trip_id, finish_date) ->
    $http.post('/challenge/create.json', {trip_id: trip_id, finish_date: finish_date})

  getChallenges: () ->
    $http.get('/challenge/all.json')

  joinChallenge: (challenge_id) ->
    $http.post('/challenge/join.json', {challenge_id: challenge_id})

  getChallengeTrips: (challenge_id) ->
    $http.post('challenge/trips.json', {id: challenge_id})