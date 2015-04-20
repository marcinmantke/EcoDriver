angular.module('EcoApp').controller 'LoginModalInstanceCtrl', ($scope, $modalInstance) ->
  $scope.ok = ->
    $modalInstance.close

  $scope.cancel = ->
    $modalInstance.dismiss 'cancel'