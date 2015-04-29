angular.module('EcoApp').controller 'LoginCtrl', ($rootScope, $scope, $modal, $log) ->
  $rootScope.isRegistrationPage = false
  $scope.counter = 0

  $scope.open = (size) ->
    modalInstance = $modal.open(
      templateUrl: 'LoginModalContent.html'
      controller: 'ModalInstanceCtrl'
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

  $scope.showModal = ->
    if $scope.counter == 0
      $scope.open('sm') 
      $scope.counter = 1 