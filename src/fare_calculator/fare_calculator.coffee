'use strict'

angular.module 'app.fareCalculator', ['ui.router']

.constant 'metrocardRates',
  BONUS_PERCENT : 5
  RIDE_COST : 2.50
  TRANSACTION_MAX : 80

.config ['$stateProvider', '$urlRouterProvider',
($stateProvider, $urlRouterProvider) ->

  $stateProvider.state 'calculator',
    url : '/'
    templateUrl : 'fare_calculator/fare_calculator.html'
    controller : 'FareCalculator'
    controllerAs : 'FareCalculatorController'

]

.service 'fares',
['metrocardRates', (metrocardRates) ->

  bonus = metrocardRates.BONUS_PERCENT / 100 + 1.0

  createFareMultiples = (max) ->
    max = if max > metrocardRates.TRANSACTION_MAX then metrocardRates.TRANSACTION_MAX else max
    fareMultiple = 0
    fares = []
    while fareMultiple <= max
      fareMultiple += metrocardRates.RIDE_COST
      fares.push fareMultiple
    fares

  # polyfill Math.trunc
  Math.trunc ||= (value) ->
    if value < 0 then Math.ceil(value) else Math.floor(value)

  # get change as whole number i.e., 0.25 -> 25
  getChange = (cost) ->
    parseInt((cost - Math.trunc(cost)).toFixed(2) * 100)

  amountsToAdd : (balanceLeft, maxToAdd) ->
    purchases = []
    for fare in createFareMultiples(maxToAdd) by -1
      toAdd = ((fare - balanceLeft) / bonus).toFixed 2
      # value to add must be divisible by 5
      if !(getChange(toAdd) % 5) and toAdd > 0
        purchases.push
          amount : toAdd,
          rides : fare / metrocardRates.RIDE_COST
    purchases
]

.controller 'FareCalculator',
class FareCalculator

  @$inject : ['fares']

  purchaseMaximum : 40

  constructor : (@fares) ->

  updatePurchaseAmounts : ->
    @purchaseAmounts = @fares.amountsToAdd Number(@remainingBalance), Number(@purchaseMaximum)