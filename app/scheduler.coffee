class Scheduler
  next: 0
  current: null

  constructor: (@root, @schedule) ->

  run: ->
    @showNext()

  showNext: ->
    if @current?
      @current.view.stop()

    if @next >= @schedule.length
      @next = 0

    @current = @schedule[@next]
    cname = @current.view.constructor.name
    console.log "Scheduler is about to render: ", cname
    rendered = @current.view.render(@root)
    if not rendered
      # current view failed, show the alternative view.
      if @current.alternative?
        aname = @current.alternative.constructor.name
        console.log "Scheduler will render #{aname} instead of #{cname}"
        @current.alternative.render(@root)

      else
        # skip to te next step
        console.log "#{cname} failed. Skipping to the next view."
        @next = @next + 1
        @showNext()
        return

    @next = @next + 1
    @timer = setTimeout(@showNext.bind(@), @current.duration)

module.exports = Scheduler
