angular.module('EcoApp').controller 'LoginCtrl', ($rootScope, $scope, $modal, $log) ->
  $rootScope.isRegistrationPage = false

  $scope.open = (size) ->
    modalInstance = $modal.open(
      templateUrl: 'LoginModalContent.html'
      controller: 'LoginModalInstanceCtrl'
      size: size
    )

  $scope.onLoginClicked = ->
    $rootScope.isRegistrationPage = false
    $scope.open('sm')
    console.log($scope.isRegistrationPage)

  $scope.onRegistrationClicked = ->
    $rootScope.isRegistrationPage = true
    $scope.open('sm')
    console.log($scope.isRegistrationPage)    