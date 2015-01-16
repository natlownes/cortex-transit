View = require '../index'

class AdView extends View
  constructor: (@adService, @adPlayer) ->
    @adService.fetch()

  stop: ->

  render: (node) ->
    ad = @adService.get()
    if not ad?
      # this will force the scheduler to render the fallback view.
      return false

    html = """
    <div class="player">
      <video src="" autoplay muted></video>
      <img src="" />
    </div>
    """
    node.html(html)
    @video = document.querySelector('.player video')
    @image = document.querySelector('.player img')

    @adPlayer.play(ad, @video, @image).then (=>
      @adService.finalize(ad)
    ), (=>
      @adService.expire(ad)
      console.log "Failed to play ad: ", ad
    )

    true

module.exports = AdView
