angular.module('EcoApp').controller 'DashboardCtrl', ($rootScope, $scope, Trip, Challenge, toastr) ->
  Trip.getDashboard().success (data) ->
    $scope.dashboard = data

  Trip.getMyTrips().success (data) ->
    $scope.mytrips = data

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