'use strict'

angular.module 'app.fareCalculator', ['ui.router']

.constant 'metrocardRates',
  BONUS_PERCENT : 5
  RIDE_COST : 2.50

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

  # polyfill Math.trunc
  Math.trunc ||= (value) ->
    if value < 0 then Math.ceil(value) else Math.floor(value)

  # get change as whole number i.e., 0.25 -> 25
  getChange = (cost) ->
    parseInt((cost - Math.trunc(cost)).toFixed(2) * 100)

  amountsToAdd : (balanceLeft, maxToAdd) ->
    fareMultiple = 0
    fares = []
    purchases = []

    while fareMultiple < maxToAdd
      fareMultiple += metrocardRates.RIDE_COST
      fares.push fareMultiple

    for fare in fares by -1
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