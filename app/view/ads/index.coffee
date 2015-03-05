inject                    = require 'honk-di'
{AdCache}                 = require 'vistar-html5player'
{AdStream}                = require 'vistar-html5player'
markAdvertisementAsPlayed = require('vistar-html5player').Player.setAsPlayed
{ProofOfPlay}             = require 'vistar-html5player'

Player = require './player'
View   = require '../index'

CortexPlayer = window.Cortex?.player


class AdView extends View
  done: false

  adstream:     inject AdStream
  cache:        inject AdCache
  proofOfPlay:  inject ProofOfPlay
  adPlayer:     inject Player

  constructor: ->
    @ads = @adstream.pipe(@cache)

  stop: ->

  isDone: ->
    @done

  render: (node) ->
    ad = @ads.read(1)

    if not ad?
      @done = true
      console.log "AdView doesn't have any ads to render."
      # this will force the scheduler to render the fallback view.
      return false

    if CortexPlayer.hasNativeVideoSupport()
      html = """
        <div class="player">
          <img src="" />
        </div>
      """
      node.html(html)
      @video = undefined
    else
      html = """
        <div class="player">
          <video autoplay muted>
            <source></source>
          </video>
          <img src="" />
        </div>
      """
      node.html(html)
      @video = document.querySelector('.player video')

    @image = document.querySelector('.player img')
    @done = false
    @adPlayer.play(ad, @video, @image).then (=>
      console.log "Player finished with success..."
      @done = true
      markAdvertisementAsPlayed ad, true
      @proofOfPlay.write(ad)
    ), (=>
      console.log "Player finished with error..."
      # view is done, even when there was an error.
      @done = true
      markAdvertisementAsPlayed ad, false
      @proofOfPlay.write(ad)
      console.log "Failed to play ad: ", ad
    )

    true


module.exports = AdView
