ANIMATION_DURATION = 300

class Scheduler
  next: 0
  current: null

  constructor: (@root, @schedule) ->

  run: ->
    @showNext()

  showNext: ->
    if @current? and not @current.view.isDone()
      console.log "Current view is not done yet. Will check in 500ms."
      setTimeout(@showNext.bind(@), 500)
      return

    @root.fadeOut ANIMATION_DURATION, =>
      @current?.view.stop()

      if @next >= @schedule.length
        @next = 0

      @current = @schedule[@next]
      cname = @current.view.constructor.name
      console.log "Scheduler is about to render: ", cname
      rendered = @current.view.render(@root)
      if not rendered
        if @current.alternative?
          aname = @current.alternative.constructor.name
          console.log "Scheduler will render #{aname} instead of #{cname}"
          @current.alternative.render(@root)

        else
          # skip to the next stop
          console.log "#{cname} failed. Skipping to the next view."
          @next = @next + 1
          @showNext()
          return

      @root.fadeIn(ANIMATION_DURATION)
      @next = @next + 1
      setTimeout(@showNext.bind(@), @current.duration)

module.exports = Scheduler
