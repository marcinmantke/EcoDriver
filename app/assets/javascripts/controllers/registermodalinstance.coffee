angular.module('EcoApp').controller 'RegisterModalInstanceCtrl', ($scope, $modalInstance) ->
  $scope.ok = ->
    $modalInstance.close

  $scope.cancel = ->
    $modalInstance.dismiss 'cancel'