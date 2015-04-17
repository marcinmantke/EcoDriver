angular.module('EcoApp').controller 'LoginCtrl', ($scope, $modal, $log) ->

  $scope.open = (size) ->
    modalInstance = $modal.open(
      templateUrl: 'LoginModalContent.html'
      controller: 'LoginModalInstanceCtrl'
      size: size
      resolve: items: ->
        $scope.items
    )
    modalInstance.result.then ((selectedItem) ->
      $scope.selected = selectedItem
      return
    ), ->
      $log.info 'Modal dismissed at: ' + new Date
      return
    return

  return