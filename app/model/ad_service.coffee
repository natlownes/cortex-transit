inject = require 'honk-di'

vistar = require 'vistar-html5player'
ProofOfPlay = vistar.ProofOfPlay

AdRequest = require './ad_request'

Cacher = require './cacher'

class AdService
  @scope:     'singleton'

  request:    inject AdRequest
  pop:        inject ProofOfPlay
  cacher:     inject Cacher
  ads:        new Array()

  fetch: ->
    success = (response) ->
      for ad in (response?.advertisement or [])
        @cacher.cacheAd ad
        @ads.push ad

    # Ask for two ads to prepare AdView for next two ad slots.
    # TODO(hamza): Check with Vistar to see if there's a better way of doing
    # this.
    @request.fetch().then(success.bind(@)).done()
    @request.fetch().then(success.bind(@)).done()

  get: ->
    if @ads.length > 0
      ad = @ads.shift()
      if @ads.length == 0
        @fetch()

      ad
    else
      undefined

  finalize: (ad) ->
    console.log "POP: ", ad.asset_url
    pop.confirm(ad)

  expire: (ad) ->
    console.log "EXPIRE: ", ad.asset_url
    pop.expire(ad)


module.exports = AdService
