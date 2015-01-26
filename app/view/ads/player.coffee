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

  playVideo: (source, advertisement) ->
    @hide()
    source.setAttribute 'src', advertisement.asset_url

  play: (advertisement, videoContainer, imageContainer) ->
    @image = imageContainer
    @video = videoContainer
    new promise (resolve, reject) =>
      if advertisement.mime_type.match(/^image/)
        @playImage(advertisement, resolve)
      else if advertisement.mime_type.match(/^video/)
        @video.addEventListener 'ended', resolve
        @video.addEventListener 'stalled', (e) =>
          console.log "video player is stalled.", e
          reject e
        sources = @video.querySelectorAll('source')
        source = sources[sources.length - 1]
        source.addEventListener 'error', (e) =>
          console.log "video player got an error: ", e
          reject e
        @video.addEventListener 'play', =>
          @video.className = ''
        @playVideo(source, advertisement)
      else
        reject()

module.exports = Player
