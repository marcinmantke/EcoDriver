angular.module('EcoApp').controller 'LoginModalInstanceCtrl', ($scope, $modalInstance) ->
  $scope.ok = ->
    $modalInstance.close
    return

  $scope.cancel = ->
    $modalInstance.dismiss 'cancel'
    return

  return