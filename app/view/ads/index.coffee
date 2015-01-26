View = require '../index'

class AdView extends View
  done: false

  constructor: (@adService, @adPlayer) ->
    @adService.fetch()

  stop: ->

  isDone: ->
    @done

  render: (node) ->
    ad = @adService.get()

    if not ad?
      @done = true
      # this will force the scheduler to render the fallback view.
      return false

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
      @adService.finalize(ad)
    ), (=>
      console.log "Player finished with error..."
      # view is done, even when there was an error.
      @done = true
      @adService.expire(ad)
      console.log "Failed to play ad: ", ad
    )

    true

module.exports = AdView
