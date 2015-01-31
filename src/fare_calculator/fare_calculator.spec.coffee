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
          .toEqual 4
        expect amounts[0]?.rides
          .toEqual 16
        expect amounts[0]?.amount
          .toEqual '38.10'

      it 'takes a maximum-to-add value', ->
        amounts = fares.amountsToAdd 10, 20
        expect amounts?.length
          .toEqual 1
        expect amounts[0]?.rides
          .toEqual 9
        expect amounts[0]?.amount
          .toEqual '11.90'

      it 'caps the max-to-add at TRANSACTION_MAX', inject (metrocardRates) ->
        amounts = fares.amountsToAdd 10, metrocardRates.TRANSACTION_MAX + 15
        expect Number(amounts[0]?.amount) <= metrocardRates.TRANSACTION_MAX
          .toBe true
