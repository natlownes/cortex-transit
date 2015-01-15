moment = require 'moment'
View = require './view'
EventStream = require 'event-stream'

class AdView extends View
  hasInitialized: false

  constructor: (@adStream, @adPlayer, @proofOfPlay) ->
    @control = EventStream.pause()
    @adStream.pipe(@control).pipe(@adPlayer).pipe(@proofOfPlay)

  stop: ->
    @control.pause()

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


module.exports = AdView
