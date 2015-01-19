inject = require 'honk-di'

vistar = require 'vistar-html5player'
ProofOfPlay = vistar.ProofOfPlay

AdRequest = require './ad_request'

class AdCacher
  imgCacheIdx: -1
  vidCacheIdx: -1

  getImgCid: ->
    @imgCacheIdx = @imgCacheIdx + 1
    if @imgCacheIdx > 5
      @imgCacheIdx = 0

    @imgCacheIdx

  getVidCid: ->
    @vidCacheIdx = @vidCacheIdx + 1
    if @vidCacheIdx > 5
      @vidCacheIdx = 0

    @vidCacheIdx

  cacheImage: (advertisement) ->
    console.log "CACHE: img: ", advertisement.asset_url
    id = @getImgCid()
    cacheId = "cache-img-#{id}"
    img = $("##{cacheId}")
    if img.length == 0
      img = $("<img id=\"#{cacheId}\">")
    img.attr('src', advertisement.asset_url)
    img.css('display', 'none')
    img.appendTo('body')

  cacheVideo: (advertisement) ->
    console.log "CACHE: vid: ", advertisement.asset_url
    id = @getVidCid()
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
      for ad in (response?.advertisement or [])
        @cacher.cache ad
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
