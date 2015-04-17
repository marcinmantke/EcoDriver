angular.module('EcoApp').controller 'RegisterCtrl', ($scope, $modal, $log) ->

  $scope.open = (size) ->
    modalInstance = $modal.open(
      templateUrl: 'RegisterModalContent.html'
      controller: 'RegisterModalInstanceCtrl'
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