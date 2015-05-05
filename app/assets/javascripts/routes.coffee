angular.module('EcoApp')
  .config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise('/mytrips')

    $stateProvider
      .state 'ranking',
        url: '/ranking',
        controller: 'RankingCtrl',
        templateUrl: 'ranking/index.html'

      .state 'mytrips',
        url: '/mytrips',
        controller: 'TripsCtrl',
        templateUrl: 'trips/mytrips.html'

      .state 'challenges',
        url: '/challenges',
        controller: 'ChallengesCtrl',
        templateUrl: 'challenges/index.html'
