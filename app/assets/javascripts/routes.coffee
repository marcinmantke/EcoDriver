angular.module('EcoApp', ['templates', 'ui.router'])
  .config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise('/')

    $stateProvider
      .state 'trips',
        url: '/',
        controller: 'TripsCtrl',
        templateUrl: 'trips/index.html'

       .state 'ranking',
        url: '/ranking',
        controller: 'TripsCtrl',
        templateUrl: 'ranking/index.html'

       .state 'mytrips',
        url: '/mytrips',
        controller: 'MyTripsCtrl',
        templateUrl: 'trips/mytrips.html'	
