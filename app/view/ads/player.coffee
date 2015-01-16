promise     = require 'promise'

class Player
  _timeoutId:  null

  hide: ->
    @video?.className = 'hidden'
    @image?.className = 'hidden'

  playImage: (advertisement, done) ->
    @hide()
    duration = advertisement.length_in_milliseconds
    finished = =>
      clearTimeout(@_timeoutId)
      done()

    @image?.setAttribute 'src', advertisement.asset_url
    @image?.className = ''

    @_timeoutId = setTimeout finished, duration

  playVideo: (advertisement) ->
    @hide()
    @video?.setAttribute 'src', advertisement.asset_url

  play: (advertisement, videoContainer, imageContainer) ->
    @image = imageContainer
    @video = videoContainer
    new promise (resolve, reject) =>
      if advertisement.mime_type.match(/^image/)
        @playImage(advertisement, resolve)
      else if advertisement.mime_type.match(/^video/)
        @video.addEventListener 'ended', resolve
        @video.addEventListener 'play', =>
          @video.className = ''
        @playVideo(advertisement)
      else
        reject()

module.exports = Player
