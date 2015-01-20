class Cacher
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

  cacheImage: (url) ->
    console.log "CACHE: img: ", url
    id = @getImgCid()
    cacheId = "cache-img-#{id}"
    img = $("##{cacheId}")
    if img.length == 0
      img = $("<img id=\"#{cacheId}\">")
    img.attr('src', url)
    img.css('display', 'none')
    img.appendTo('body')

  cacheVideo: (url) ->
    return
    console.log "CACHE: vid: ", url
    id = @getVidCid()
    cacheId = "cache-vid-#{id}"
    vid = $("##{cacheId}")
    if vid.length == 0
      vid = $("<video id=\"#{cacheId}\" preload=\"auto\" muted>")
    vid.attr('src', url)
    vid.css('display', 'none')
    vid.appendTo('body')

  cacheAd: (advertisement) ->
    mimeType    = advertisement.mime_type
    if advertisement.mime_type.match(/^image/)
      @cacheImage(advertisement.asset_url)
    else if advertisement.mime_type.match(/^video/)
      @cacheVideo(advertisement.asset_url)

module.exports = Cacher
