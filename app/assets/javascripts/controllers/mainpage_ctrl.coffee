angular.module('EcoApp').controller 'MainPageCtrl', ($scope) ->

  $scope.myInterval = 10000
  $scope.slides = [
    { 
      image: '/assets/car3.jpg';
      caption: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
    }

    { 
      image: '/assets/car3.jpg';
      caption: 'ABC';
    }
  ]
  return