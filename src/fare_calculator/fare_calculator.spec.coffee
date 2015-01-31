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
