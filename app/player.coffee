inject      = require 'honk-di'
{Transform} = require('stream')


class Player extends Transform
  config:      inject 'config'

  _timeoutId:  null
  _currentAd:  null

  constructor: ->
    super(highWaterMark: @config.queueSize, objectMode: true)

  setVideoContainer: (video) ->
    @video = video
    @video.addEventListener 'ended', @_videoFinished
    @video.addEventListener 'play', =>
      @emit 'log', name: 'Player', message: 'video playing'
      @video.className = ''

  setImageContainer: (image) ->
    @image = image

  hide: ->
    @video.className = 'hidden'
    @image.className = 'hidden'

  playImage: (advertisement, callback) ->
    @hide()
    duration = advertisement.length_in_milliseconds
    finished = =>
      clearTimeout(@_timeoutId)
      ad = @_setAsPlayed(advertisement, true)
      @emit 'log', name: 'Player', message: 'image stopping'
      callback(null, ad)

    @image.setAttribute 'src', advertisement.asset_url
    @emit 'log', name: 'Player', message: 'image playing'
    @image.className = ''

    @_timeoutId = setTimeout finished, duration

  playVideo: (advertisement) ->
    @hide()
    duration = advertisement.length_in_milliseconds
    @video.setAttribute 'src', advertisement.asset_url

  _transform: (advertisement, encoding, callback) ->
    @emit 'log', name: 'Player', message:
      "receiving advertisement, buf length #{@_writableState.buffer.length}"
    @_currentAd = advertisement
    mimeType    = advertisement.mime_type
    if advertisement.mime_type.match(/^image/)
      @playImage(advertisement, callback)
    else if advertisement.mime_type.match(/^video/)
      @playVideo(advertisement, callback)
    else
      callback(null, @_setAsPlayed(advertisement, false))

  _videoFinished: =>
    clearTimeout(@_timeoutId)
    ad = @_setAsPlayed(@_currentAd, true)
    @emit 'log', name: 'Player', message: 'video stopping'
    @_transformState.afterTransform(null, ad)

  _setAsPlayed: (ad, wasPlayed) ->
    ad?['html5player'] =
      was_played: wasPlayed
    ad


module.exports = Player
