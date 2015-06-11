angular.module('EcoApp').directive 'resize', ($window) ->
  (scope, element) ->
    w = angular.element($window)

    scope.getWindowDimensions = ->
      {
        'h': w.height()
        'w': w.width()
      }

    scope.$watch scope.getWindowDimensions, ((newValue, oldValue) ->
      scope.windowHeight = newValue.h
      scope.windowWidth = newValue.w

      scope.style = (width, height) ->
        {
          'height': ((newValue.h - 100) * height) + 'px' if height != null
          'width': ((newValue.w - 100) * width) + 'px' if width != null
        }

      return
    ), true
    w.bind 'resize', ->
      scope.$apply()
      return
    return