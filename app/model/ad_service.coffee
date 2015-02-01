inject = require 'honk-di'

vistar = require 'vistar-html5player'
ProofOfPlay = vistar.ProofOfPlay

CortexNet = window.Cortex?.net

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
        if ad.mime_type.match(/^video/)
          opts =
            cache: 24 * 60 * 60 * 1000
          CortexNet.download(ad.asset_url, opts).then (
            (path) =>
              console.log "Replacing asset url #{ad.asset_url} with #{path}"
              ad.asset_url = path
              @ads.push ad
          ), (
            (err) =>
              console.log "Failed to fetch ad asset: #{ad.asset_url}. err=", err
              @expire ad
          )
        else
          @cacher.cacheAd ad
          @ads.push ad

    # Ask for two ads to prepare AdView for next two ad slots.
    # TODO(hamza): Check with Vistar to see if there's a better way of doing
    # this.
    try
      @request.fetch().then(success.bind(@)).done()
      @request.fetch().then(success.bind(@)).done()
    catch e
      console.log "Failed to fetch ads: ", e

  get: ->
    if @ads.length > 0
      ad = @ads.shift()
      if @ads.length == 0
        @fetch()

      ad
    else
      @fetch()
      undefined

  finalize: (ad) ->
    console.log "POP: ", ad.asset_url
    try
      @pop.confirm(ad)
    catch e
      console.log "POP failed. ", e

  expire: (ad) ->
    console.log "EXPIRE: ", ad.asset_url
    try
      @pop.expire(ad)
    catch e
      console.log "EXPIRE failed. ", e


module.exports = AdService
