'use strict'

angular.module 'app', [
  'ui.router', 'app.fareCalculator', 'app.templates'
]

.config [
  '$locationProvider', '$urlRouterProvider',
  ($locationProvider, $urlRouterProvider) ->
    $locationProvider.html5Mode true
    $urlRouterProvider.otherwise '/'
]