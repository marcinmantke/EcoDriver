angular.module('EcoApp').controller 'RegisterModalInstanceCtrl', ($scope, $modalInstance) ->
  $scope.ok = ->
    $modalInstance.close
    return

  $scope.cancel = ->
    $modalInstance.dismiss 'cancel'
    return

  return