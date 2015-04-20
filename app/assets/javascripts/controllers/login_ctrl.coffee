angular.module('EcoApp').controller 'LoginCtrl', ($scope, $modal, $log) ->

  $scope.open = (size) ->
    modalInstance = $modal.open(
      templateUrl: 'LoginModalContent.html'
      controller: 'LoginModalInstanceCtrl'
      size: size
    )