moment = require 'moment'
View = require './view'

class AdView extends View
  hasInitialized: false

  constructor: (@adStream, @adPlayer, @proofOfPlay) ->

  stop: ->
    if @hasInitialized
      @adStream.pause()

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

    if not @hasInitialized
      @adStream.pipe(@adPlayer).pipe(@proofOfPlay)
      @hasInitialized = true

    else
      @adStream.resume()

module.exports = AdView
