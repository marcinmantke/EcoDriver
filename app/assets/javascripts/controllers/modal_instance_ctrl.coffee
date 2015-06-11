angular.module('EcoApp').controller 'ModalInstanceCtrl', ($scope, $modalInstance) ->
  $scope.ok = ->
    $modalInstance.close

  $scope.cancel = ->
    $modalInstance.dismiss 'cancel'