describe 'FareCalculator', ->

  beforeEach ->
    module 'app.fareCalculator'

  describe 'fares service', ->

    describe 'amountsToAdd', ->
      fares = null

      beforeEach inject (_fares_) ->
        fares = _fares_

      it 'takes a $0 balance', ->
        amounts = fares.amountsToAdd 0, 40
        expect amounts?.length
          .toEqual 5
        expect amounts[0]?.rides
          .toEqual 16
        expect amounts[0]?.amount
          .toEqual '38.10'
        expect amounts[4]?.rides
          .toEqual 1
        expect amounts[4]?.amount
          .toEqual '2.50'

      it 'calculates the bonus for amounts > the bonus minimum', inject (metrocardRates) ->
        amounts = fares.amountsToAdd 0.01, 20
        expect Number(amounts?[0]?.amount) >= metrocardRates.BONUS_MIN
          .toBe true

      it 'takes a maximum-to-add value', ->
        maxToAdd = 20
        amounts = fares.amountsToAdd 10, maxToAdd
        expect Number(amounts[0]?.amount) <= maxToAdd
          .toBe true

      it 'caps the max-to-add at TRANSACTION_MAX', inject (metrocardRates) ->
        amounts = fares.amountsToAdd 10, metrocardRates.TRANSACTION_MAX + 15
        expect Number(amounts[0]?.amount) <= metrocardRates.TRANSACTION_MAX
          .toBe true
