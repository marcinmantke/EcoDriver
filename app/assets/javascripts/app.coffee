angular.module('EcoApp', ['ui.bootstrap', 'templates', 'ui.router', 'ngMap', 'ui.autocomplete', 'toastr'])
  .config ($provide, $httpProvider) ->
    # CSFR token
    $httpProvider.defaults.headers.common['X-CSRF-Token'] =
      angular.element(document.querySelector('meta[name=csrf-token]')).attr('content')

