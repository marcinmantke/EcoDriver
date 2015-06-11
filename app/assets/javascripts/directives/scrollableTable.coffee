do (angular) ->

  _getScale = (sizeCss) ->
    parseInt sizeCss.replace(/px|%/, ''), 10

  'use strict'
  angular.module('EcoApp').directive('scrollableTable', [
    '$timeout'
    '$q'
    '$parse'
    ($timeout, $q, $parse) ->
      {
        transclude: true
        restrict: 'E'
        scope:
          rows: '=watch'
          sortFn: '='
        template: '<div class="scrollableContainer">' + '<div class="headerSpacer"></div>' + '<div class="scrollArea" ng-transclude></div>' + '</div>'
        controller: [
          '$scope'
          '$element'
          '$attrs'
          ($scope, $element, $attrs) ->
            # define an API for child directives to view and modify sorting parameters

            defaultCompare = (row1, row2) ->
              exprParts = $scope.sortExpr.match(/(.+)\s+as\s+(.+)/)
              scope = {}
              scope[exprParts[1]] = row1
              x = $parse(exprParts[2])(scope)
              scope[exprParts[1]] = row2
              y = $parse(exprParts[2])(scope)
              if x == y
                return 0
              if x > y then 1 else -1

            scrollToRow = (row) ->
              offset = $element.find('.headerSpacer').height()
              currentScrollTop = $element.find('.scrollArea').scrollTop()
              $element.find('.scrollArea').scrollTop currentScrollTop + row.position().top - offset
              return

            # Set fixed widths for the table headers in case the text overflows.
            # There's no callback for when rendering is complete, so check the visibility of the table
            # periodically -- see http://stackoverflow.com/questions/11125078

            waitForRender = ->
              deferredRender = $q.defer()

              wait = ->
                if $element.find('table:visible').length == 0
                  $timeout wait, 100
                else
                  deferredRender.resolve()
                return

              $timeout wait
              deferredRender.promise

            fixHeaderWidths = ->
              if !$element.find('thead th .th-inner').length
                $element.find('thead th').wrapInner '<div class="th-inner"></div>'
              if $element.find('thead th .th-inner:not(:has(.box))').length
                $element.find('thead th .th-inner:not(:has(.box))').wrapInner '<div class="box"></div>'
              $element.find('table th .th-inner:visible').each (index, el) ->
                el = angular.element(el)
                width = el.parent().width()
                lastCol = $element.find('table th:visible:last')
                headerWidth = width
                if lastCol.css('text-align') != 'center'
                  hasScrollbar = $element.find('.scrollArea').height() < $element.find('table').height()
                  if lastCol[0] == el.parent()[0] and hasScrollbar
                    headerWidth += $element.find('.scrollArea').width() - $element.find('tbody tr').width()
                    headerWidth = Math.max(headerWidth, width)
                minWidth = _getScale(el.parent().css('min-width'))
                title = el.parent().attr('title')
                headerWidth = Math.max(minWidth, headerWidth)
                el.css 'width', headerWidth
                if !title
                  # ordinary column(not sortableHeader) has box child div element that contained title string.
                  title = el.find('.title .ng-scope').html() or el.find('.box').html()
                el.attr 'title', title.trim()
                return
              headersAreFixed.resolve()
              return

            renderChains = ->
              resizeQueue = waitForRender().then(fixHeaderWidths)
              customHandlers = $scope.headerResizeHanlers or []
              i = 0
              while i < customHandlers.length
                resizeQueue = resizeQueue.then(customHandlers[i])
                i++
              resizeQueue

            @getSortExpr = ->
              $scope.sortExpr

            @isAsc = ->
              $scope.asc

            @setSortExpr = (exp) ->
              $scope.asc = true
              $scope.sortExpr = exp
              return

            @toggleSort = ->
              $scope.asc = !$scope.asc
              return

            @doSort = (comparatorFn) ->
              if comparatorFn
                $scope.rows.sort (r1, r2) ->
                  compared = comparatorFn(r1, r2)
                  if $scope.asc then compared else compared * -1
              else
                $scope.rows.sort (r1, r2) ->
                  compared = defaultCompare(r1, r2)
                  if $scope.asc then compared else compared * -1
              return

            @renderTalble = ->
              waitForRender().then fixHeaderWidths

            @getTableElement = ->
              $element

            ###*
            # append handle function to execute after table header resize.
            ###

            @appendTableResizingHandler = (handler) ->
              handlerSequence = $scope.headerResizeHanlers or []
              i = 0
              while i < handlerSequence.length
                if handlerSequence[i].name == handler.name
                  return
                i++
              handlerSequence.push handler
              $scope.headerResizeHanlers = handlerSequence
              return

            $scope.$on 'rowSelected', (event, rowId) ->
              row = $element.find('.scrollArea table tr[row-id=\'' + rowId + '\']')
              if row.length == 1
                # Ensure that the headers have been fixed before scrolling, to ensure accurate
                # position calculations
                $q.all([
                  waitForRender()
                  headersAreFixed.promise
                ]).then ->
                  scrollToRow row
                  return
              return
            headersAreFixed = $q.defer()
            # when the data model changes, fix the header widths.  See the comments here:
            # http://docs.angularjs.org/api/ng.$timeout
            $scope.$watch 'rows', (newValue, oldValue) ->
              if newValue
                renderChains $element.find('.scrollArea').width()
                # clean sort status and scroll to top of table once records replaced.
                $scope.sortExpr = null
                # FIXME what is the reason here must scroll to top? This may cause confusing if using scrolling to implement pagination.
                $element.find('.scrollArea').scrollTop 0
              return
            $scope.asc = !$attrs.hasOwnProperty('desc')
            $scope.sortAttr = $attrs.sortAttr
            $element.find('.scrollArea').scroll (event) ->
              $element.find('thead th .th-inner').css 'margin-left', 0 - event.target.scrollLeft
              return
            $scope.$on 'renderScrollableTable', ->
              renderChains $element.find('.scrollArea').width()
              return
            angular.element(window).on 'resize', ->
              $scope.$apply()
              return
            $scope.$watch (->
              $element.find('.scrollArea').width()
            ), (newWidth, oldWidth) ->
              if newWidth * oldWidth <= 0
                return
              renderChains()
              return
            return
        ]
      }
  ]).directive('sortableHeader', [ ->
    {
      transclude: true
      scope: true
      require: '^scrollableTable'
      template: '<div class="box">' + '<div ng-mouseenter="enter()" ng-mouseleave="leave()">' + '<div class="title" ng-transclude></div>' + '<span class="orderWrapper">' + '<span class="order" ng-show="focused || isActive()" ng-click="toggleSort($event)" ng-class="{active:isActive()}">' + '<i ng-show="isAscending()" class="glyphicon glyphicon-chevron-up"></i>' + '<i ng-show="!isAscending()" class="glyphicon glyphicon-chevron-down"></i>' + '</span>' + '</span>' + '</div>' + '</div>'
      link: (scope, elm, attrs, tableController) ->
        expr = attrs.on or 'a as a.' + attrs.col
        scope.element = angular.element(elm)

        scope.isActive = ->
          tableController.getSortExpr() == expr

        scope.toggleSort = (e) ->
          if scope.isActive()
            tableController.toggleSort()
          else
            tableController.setSortExpr expr
          tableController.doSort scope[attrs.comparatorFn]
          e.preventDefault()
          return

        scope.isAscending = ->
          if scope.focused and !scope.isActive()
            true
          else
            tableController.isAsc()

        scope.enter = ->
          scope.focused = true
          return

        scope.leave = ->
          scope.focused = false
          return

        scope.isLastCol = ->
          elm.parent().find('th:last-child').get(0) == elm.get(0)

        return

    }
 ]).directive 'resizable', [
    '$compile'
    ($compile) ->
      {
        restrict: 'A'
        priority: 0
        scope: true
        require: '^scrollableTable'
        link: (scope, elm, attrs, tableController) ->

          _init = ->
            thInnerElms = elm.find('table th:not(:last-child) .th-inner')
            if thInnerElms.find('.resize-rod').length == 0
              tableController.getTableElement().find('.scrollArea table').css 'table-layout', 'auto'
              resizeRod = angular.element('<div class="resize-rod" ng-mousedown="resizing($event)"></div>')
              thInnerElms.append $compile(resizeRod)(scope)
            return

          initRodPos = ->
            tableElement = tableController.getTableElement()
            headerPos = 1
            #  1 is the width of right border;
            tableElement.find('table th .th-inner:visible').each (index, el) ->
              el = angular.element(el)
              width = el.parent().width()
              minWidth = _getScale(el.parent().css('min-width'))
              width = Math.max(minWidth, width)
              el.css 'left', headerPos
              headerPos += width
              return
            return

          resizeHeaderWidth = ->
            headerPos = 1
            tableElement = tableController.getTableElement()
            tableController.getTableElement().find('table th .th-inner:visible').each (index, el) ->
              el = angular.element(el)
              width = el.parent().width()
              lastCol = tableElement.find('table th:visible:last')
              minWidth = _getScale(el.parent().css('min-width'))
              width = Math.max(minWidth, width)
              #following are resize stuff, to made th-inner position correct.
              #last column's width should be automatically, to avoid horizontal scroll.
              if lastCol[0] != el.parent()[0]
                el.parent().css 'width', width
              el.css 'left', headerPos
              headerPos += width
              return
            return

          _resetColumnsSize = (tableWidth) ->
            tableElement = tableController.getTableElement()
            columnLength = tableElement.find('table th:visible').length
            lastCol = tableElement.find('table th:visible:last')
            tableElement.find('table th:visible').each (index, el) ->
              el = angular.element(el)
              if lastCol.get(0) == el.get(0)
                #last column's width should be automaically, to avoid horizontal scroll.
                el.css 'width', 'auto'
                return
              _width = el.data('width')
              if /\d+%$/.test(_width)
                #percentage
                _width = Math.ceil(tableWidth * _getScale(_width) / 100)
              else
                # if data-width not exist, use average width for each columns.
                _width = tableWidth / columnLength
              el.css 'width', _width + 'px'
              return
            tableController.renderTalble().then resizeHeaderWidth()
            return

          tableController.appendTableResizingHandler ->
            _init()
            return
          tableController.appendTableResizingHandler ->
            tableElement = tableController.getTableElement().find('.scrollArea table')
            if tableElement.css('table-layout') == 'auto'
              initRodPos()
            else
              _resetColumnsSize tableElement.parent().width()
            return

          scope.resizing = (e) ->
            screenOffset = tableController.getTableElement().find('.scrollArea').scrollLeft()
            thInnerElm = angular.element(e.target).parent()
            thElm = thInnerElm.parent()
            startPoint = _getScale(thInnerElm.css('left')) + thInnerElm.width() - screenOffset
            movingPos = e.pageX
            _document = angular.element(document)
            _body = angular.element('body')
            coverPanel = angular.element('.scrollableContainer .resizing-cover')
            scaler = angular.element('<div class="scaler">')
            _body.addClass 'scrollable-resizing'
            coverPanel.addClass 'active'
            angular.element('.scrollableContainer').append scaler
            scaler.css 'left', startPoint
            _document.bind 'mousemove', (e) ->
              offsetX = e.pageX - movingPos
              movedOffset = _getScale(scaler.css('left')) - startPoint
              widthOfActiveCol = thElm.width()
              nextElm = thElm.nextAll('th:visible').first()
              minWidthOfActiveCol = _getScale(thElm.css('min-width'))
              widthOfNextColOfActive = nextElm.width()
              minWidthOfNextColOfActive = _getScale(nextElm.css('min-width'))
              movingPos = e.pageX
              e.preventDefault()
              if offsetX > 0 and widthOfNextColOfActive - movedOffset <= minWidthOfNextColOfActive or offsetX < 0 and widthOfActiveCol + movedOffset <= minWidthOfActiveCol
                #stopping resize if user trying to extension and the active/next column already minimised.
                return
              scaler.css 'left', _getScale(scaler.css('left')) + offsetX
              return
            _document.bind 'mouseup', (e) ->
              e.preventDefault()
              scaler.remove()
              _body.removeClass 'scrollable-resizing'
              coverPanel.removeClass 'active'
              _document.unbind 'mousemove'
              _document.unbind 'mouseup'
              offsetX = _getScale(scaler.css('left')) - startPoint
              newWidth = thElm.width()
              minWidth = _getScale(thElm.css('min-width'))
              nextElm = thElm.nextAll('th:visible').first()
              widthOfNextColOfActive = nextElm.width()
              minWidthOfNextColOfActive = _getScale(nextElm.css('min-width'))
              tableElement = tableController.getTableElement().find('.scrollArea table')
              #hold original width of cells, to display cells as their original width after turn table-layout to fixed.
              if tableElement.css('table-layout') == 'auto'
                tableElement.find('th .th-inner').each (index, el) ->
                  el = angular.element(el)
                  width = el.parent().width()
                  el.parent().css 'width', width
                  return
              tableElement.css 'table-layout', 'fixed'
              if offsetX > 0 and widthOfNextColOfActive - offsetX <= minWidthOfNextColOfActive
                offsetX = widthOfNextColOfActive - minWidthOfNextColOfActive
              nextElm.removeAttr 'style'
              newWidth += offsetX
              thElm.css 'width', Math.max(minWidth, newWidth)
              nextElm.css 'width', widthOfNextColOfActive - offsetX
              tableController.renderTalble().then resizeHeaderWidth()
              return
            return

          return

      }
  ]
  return

# ---
# generated by js2coffee 2.0.3