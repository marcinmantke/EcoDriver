angular.module('EcoApp').controller 'MainPageCtrl', ($scope, $filter) ->

  $scope.myInterval = 10000
  $scope.slides = [
    { 
      image: '/assets/car3.jpg'
      title: $filter('translate')('TITLE1')
      caption: $filter('translate')('CAPTION1')
    }

    { 
      image: '/assets/car4.jpg';
      title: $filter('translate')('TITLE2')
      caption: $filter('translate')('CAPTION2')
    }
  ]