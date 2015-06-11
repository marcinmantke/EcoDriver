angular.module('EcoApp').directive 'scrollOnClick', -> 
    restrict: 'A'
    link: (scope, $elm) ->
      $elm.on 'click', ->
        $('body').animate { scrollTop: $elm.offset().top }, 'fast'
