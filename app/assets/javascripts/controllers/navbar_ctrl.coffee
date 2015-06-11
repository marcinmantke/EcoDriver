angular.module('EcoApp').controller 'NavbarCtrl', ($scope, $location) ->

  $scope.isActive = (select_path) ->
    select_path == $location.path()
    