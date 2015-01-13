class Scheduler
  next: 0
  current: null

  constructor: (@root, @schedules) ->

  run: ->
    @showNext()

  showNext: ->
    if @current?
      @current.view.stop()

    if @next >= @schedules.length
      @next = 0

    schedule = @schedules[@next]
    schedule.view.render(@root)
    @current = schedule
    @next = @next + 1
    @timer = setTimeout(@showNext.bind(@), schedule.duration)

module.exports = Scheduler
