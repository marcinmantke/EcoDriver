angular.module('EcoApp').controller 'MainPageCtrl', ($scope) ->

  $scope.myInterval = 10000
  $scope.slides = [
    { 
      image: '/assets/car3.jpg';
      title: 'Want to try EcoDriving?';
      caption: 'See what are the benefits!';
    }

    { 
      image: '/assets/car3.jpg';
      title: 'Already convinced?';
      caption: 'Sign up!';
    }
  ]
  return