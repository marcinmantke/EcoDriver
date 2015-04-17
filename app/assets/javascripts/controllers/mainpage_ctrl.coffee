angular.module('EcoApp').controller 'MainPageCtrl', ($scope) ->
  $scope.myInterval = 5000
  slides = $scope.slides = []

  $scope.addSlide = ->
    newWidth = 600 + slides.length + 1
    slides.push
      image: 'http://placekitten.com/' + newWidth + '/300'
      text: [
        'More'
        'Extra'
        'Lots of'
        'Surplus'
      ][slides.length % 4] + ' ' + [
        'Cats'
        'Kittys'
        'Felines'
        'Cutes'
      ][slides.length % 4]
    return

  i = 0
  while i < 4
    $scope.addSlide()
    i++
  return