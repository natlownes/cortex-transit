moment = require 'moment'
{Transform} = require 'stream'

View = require './view'
EventStream = require 'event-stream'

class AdCacher extends Transform
  constructor: ->
    super(highWaterMark: 1, objectMode: true)

  cacheImage: (advertisement) ->
    console.log "Will cache img: ", advertisement.asset_url
    img = $('#cache-img')
    if img.length == 0
      img = $('<img id="cache-img">')
    img.attr('src', advertisement.asset_url)
    img.css('display', 'none')
    img.appendTo('body')

  cacheVideo: (advertisement) ->
    console.log "Will cache vid: ", advertisement.asset_url
    vid = $('#cache-vid')
    if vid.length == 0
      vid = $('<video id="cache-vid">')
    vid.attr('src', advertisement.asset_url)
    vid.css('display', 'none')
    vid.appendTo('body')

  _transform: (advertisement, encoding, callback) ->
    mimeType    = advertisement.mime_type
    if advertisement.mime_type.match(/^image/)
      @cacheImage(advertisement)
    else if advertisement.mime_type.match(/^video/)
      @cacheVideo(advertisement)

    callback(null, advertisement)

class AdView extends View
  hasInitialized: false

  constructor: (@adStream, @adPlayer, @proofOfPlay) ->
    @reader = EventStream.pause()
    @control = EventStream.pause()
    @cacher = new AdCacher()
    @adStream.pipe(@reader).pipe(@cacher).pipe(@control).pipe(@adPlayer).pipe(@proofOfPlay)
    @control.pause()
    @reader.resume()

  stop: ->
    @control.pause()
    @reader.resume()

  render: (node) ->
    html = """
    <div class="player">
      <img src="" />
      <video src="" autoplay muted>
      </video>
    </div>
    """
    node.html(html)
    @adPlayer.setVideoContainer(document.querySelector('.player video'))
    @adPlayer.setImageContainer(document.querySelector('.player img'))

    @control.resume()
    @reader.pause()


module.exports = AdView
