inject = require 'honk-di'

vistar = require 'vistar-html5player'
ProofOfPlay = vistar.ProofOfPlay

AdRequest = require './ad_request'

class AdCacher
  cacheImage: (advertisement, id) ->
    console.log "CACHE: img: ", advertisement.asset_url
    cacheId = "cache-img-#{id}"
    img = $("##{cacheId}")
    if img.length == 0
      img = $("<img id=\"#{cacheId}\">")
    img.attr('src', advertisement.asset_url)
    img.css('display', 'none')
    img.appendTo('body')

  cacheVideo: (advertisement, id) ->
    console.log "CACHE: vid: ", advertisement.asset_url
    cacheId = "cache-vid-#{id}"
    vid = $("##{cacheId}")
    if vid.length == 0
      vid = $("<video id=\"#{cacheId}\" preload=\"auto\" muted>")
    vid.attr('src', advertisement.asset_url)
    vid.css('display', 'none')
    vid.appendTo('body')

  cache: (advertisement, id) ->
    mimeType    = advertisement.mime_type
    if advertisement.mime_type.match(/^image/)
      @cacheImage(advertisement, id)
    else if advertisement.mime_type.match(/^video/)
      @cacheVideo(advertisement, id)

class AdService
  @scope:     'singleton'

  request:    inject AdRequest
  pop:        inject ProofOfPlay
  ads:        new Array()
  cacher:     new AdCacher()

  fetch: ->
    success = (response) ->
      idx = 0
      for ad in (response?.advertisement or [])
        @ads.push ad
        @cacher.cache ad, idx
        idx = idx + 1

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
