angular.module('EcoApp', ['ui.bootstrap', 'templates', 'ui.router', 'ngMap', 'ui.autocomplete',
  'toastr', 'ui.select', 'chart.js','pascalprecht.translate'])
  .config ($provide, $httpProvider, $translateProvider) ->
    # CSFR token
    $httpProvider.defaults.headers.common['X-CSRF-Token'] =
      angular.element(document.querySelector('meta[name=csrf-token]')).attr('content')

    $translateProvider.translations('en', {
      #dashboard
      CAR_STATS_HEADER: 'My current car',
      ENG_DISP: 'Engine displacement',
      FUEL_TYPE: 'Fuel type',
      MY_STATS: 'My stats',
      OVERALL_MIL: 'Overall mileage',
      TRIPS_NO: 'Number of trips',
      AVG_FUEL_CONSUMPTION: 'Average fuel consumption',
      AVG_SPEED: 'Average speed',
      diesel: 'diesel',
      petrol: 'petrol',
      lpg: 'lpg',
      RECENT_TRIPS: 'Recent trips',
      DISTANCE: 'Distance',
      AVG_RPM: 'Average RPM',
      DATE: 'Date',
      SHOW_MAP: 'Show map',
      INV_TO_CHALLENGE: 'Invitations to challenges',
      START: 'Start',
      FINISH: 'Finish',
      CREATED_BY: 'Created by',
      FINISH_DATE: 'Finish date',
      ACCEPT: 'Accept',
      REJECT: 'Reject',

      #ranking
      SELECT_DISTANCE: 'Select a distance range',
      SELECT_ENG_TYPE: 'Select an engine type'
      SELECT_ENG_DISP: 'Select an engine displacement',
      USER: 'User',
      GEAR_RATE: 'Gears change rating',
      SEARCH_USER: 'Search user',

      #challenge
      CREATE_CHALLENGE: 'Create challenge',
      ADDRES_SEARCH: 'Search addres',
      CHALLENGE_PARTICIPATE: 'Challenges in which you participate',
      CREATED_BY: 'Created by',
      CREATE: 'Create',
      CANCEL: 'Cancel',
      BACK: 'Back',
      JOIN: 'Join',
      INVITE: 'Invite',
      INVITE_PLACEHOLDER: 'Invite your friends'
    })

    .translations('pl', {
      CAR_STATS_HEADER: 'Aktualny samochód',
      ENG_DISP: 'Pojemność silnika',
      FUEL_TYPE: 'Rodzaj paliwa',
      MY_STATS: 'Podsumowanie',
      OVERALL_MIL: 'Łączny przebyty dystans',
      TRIPS_NO: 'Ilość zapisanych tras',
      AVG_FUEL_CONSUMPTION: 'Średnie spalanie',
      AVG_SPEED: 'Średnia prędkość',
      diesel: 'olej napędowy',
      petrol: 'benzyna',
      lpg: 'lpg',
      RECENT_TRIPS: 'Ostatnie zapisane trasy',
      DISTANCE: 'Dystans',
      AVG_RPM: 'Średnie obroty silnika',
      DATE: 'Data',
      SHOW_MAP: 'Pokaż mape',
      INV_TO_CHALLENGE: 'Zaproszenia do wyzwań',
      START: 'Początek',
      FINISH: 'Koniec',
      INVITED_BY: 'Zaproszenie wysłał',
      FINISH_DATE: 'Koniec wyzwania',
      ACCEPT: 'Zaakceptuj',
      REJECT: 'Odrzuć'

      #ranking
      SELECT_DISTANCE: 'Wybierz zakres dystansu',
      SELECT_ENG_TYPE: 'Wybierz typ paliwa',
      SELECT_ENG_DISP: 'Wybierz pojemność silnika',
      USER: 'Użytkownik',
      GEAR_RATE: 'Ocena zmiany biegów',
      SEARCH_USER: 'Wyszukaj użytkownika',

      #challenge
      CREATE_CHALLENGE: 'Utwórz wyzwanie',
      ADDRES_SEARCH: 'Wyszukaj adres',
      CHALLENGE_PARTICIPATE: 'Wyzwania, w których bierzesz udział',
      CREATED_BY: 'Twórca',
      CREATE: 'Utwórz',
      CANCEL: 'Anuluj'
      BACK: 'Wróć',
      JOIN: 'Dołącz',
      INVITE: 'Zaproś',
      INVITE_PLACEHOLDER: 'Zaproś swoich znajomych'
    })

    .registerAvailableLanguageKeys(['en, pl'])

    .determinePreferredLanguage()

    .fallbackLanguage('en');

