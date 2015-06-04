angular.module('EcoApp').controller 'RankingCtrl', ($http, $scope, Trip, Challenge)->
  $scope.limits = []
  $scope.limits[0] = null
  $scope.limits[1] = null
  $scope.engineDisplacement = null
  $scope.engineType = null

  Trip.getGearParams().success (data) ->
    $scope.engineDisplacements = data.displacements
    $scope.engineTypes = data.types

  $scope.getRankingTrips = ()->
    console.log $scope
    Trip.ranking($scope.engineType, $scope.engineDisplacement, $scope.limits[0], $scope.limits[1]).success (data)->
      $scope.trips = data

  $scope.setDistanceRange = (distanceRange) ->
    $scope.distanceRange = distanceRange
    if distanceRange
      $scope.limits = distanceRange.split("-")
      $scope.getRankingTrips()

  $scope.setEngineType = (engineType) ->
    $scope.engineType = engineType
    $scope.getRankingTrips()

  $scope.setEngineDisplacement = (engineDisplacement) ->
    $scope.engineDisplacement = engineDisplacement
    $scope.getRankingTrips()



  $scope.distanceRanges = [
    { display: '0 - 100 km', value: '0-100' },
    { display: '100 - 500 km', value: '100-500' },
    { display: '500 - 2 000 km', value: '500-2000' },
    { display: '2 000 - 10 000 km', value: '2000-10000' },
    { display: '10 000 - 20 000 km', value: '10000-20000' },
    { display: 'more than 20 000 km', value: '20000-999999999999' }
  ]

  $scope.getRankingTrips()

  $scope.autocompleteOption =
    options:
      html: true
      focusOpen: false
      onlySelectValid: true
      source: (request, response) ->
        Challenge.getAllUsers().success (users) ->
          data = []
          for user in users
            data.push user.username
          data = $scope.autocompleteOption.methods.filter(data, request.term)
          if !data.length
            data.push
              label: 'not found'
              value: ''
          response data
    methods: {}