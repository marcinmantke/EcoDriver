angular.module('EcoApp', ['templates', 'ui.router'])
  .config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise('/')

    $stateProvider
      .state 'trips',
        url: '/',
        controller: 'TripsCtrl',
        templateUrl: 'trips/index.html'
