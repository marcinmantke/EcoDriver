angular.module('EcoApp').factory 'Challenge', ($http) ->
  createChallenge: (trip_id, finish_date) ->
    $http.post('/challenge/create.json', {trip_id: trip_id, finish_date: finish_date})

  getChallenges: () ->
    $http.get('/challenge/all.json')

  joinChallenge: (challenge_id) ->
    $http.post('/challenge/join.json', {challenge_id: challenge_id})

  getChallengeTrips: (challenge_id, engine_type, engine_displacement) ->
    $http.post('challenge/trips.json', {id: challenge_id, engine_type: engine_type, engine_displacement: engine_displacement})

  getAllUsers: () ->
    $http.post('challenge/users.json')

  inviteUser: (user, challenge_id) ->
    $http.post('/challenge/invite.json', {user: user, challenge: challenge_id})

  invitations: () ->
    $http.get('/challenge/invitations.json')

  acceptInvitation: (invitation_id) ->
    $http.post('/challenge/accept_invitation.json', {invitation_id: invitation_id})

  rejectInvitation: (invitation_id) ->
    $http.post('/challenge/reject_invitation.json', {invitation_id: invitation_id})