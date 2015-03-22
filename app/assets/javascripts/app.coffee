angular.module('EcoApp', ['templates', 'ui.router'])
  .config ($provide, $httpProvider, $translateProvider, Rails) ->
    # CSFR token
    $httpProvider.defaults.headers.common['X-CSRF-Token'] =
      angular.element(document.querySelector('meta[name=csrf-token]')).attr('content')

