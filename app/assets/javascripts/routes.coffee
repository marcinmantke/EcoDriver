
angular.module("EcoDriverApp").config ($stateProvider, $urlRouterProvider) ->
	$urlRouterProvider.otherwise('trips');

	$stateProvider
	.state('trips', {
		url: '/trips',
		controller: 'TripsCtrl',
		templateUrl: 'trips/index.html'
  })