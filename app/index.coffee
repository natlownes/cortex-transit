inject      = require 'honk-di'

Cortex = window.Cortex

Vistar           = require 'vistar-html5player'
Ajax             = Vistar.Ajax
XMLHttpAjax      = Vistar.XMLHttpAjax

Cacher           = require './model/cacher'

Scheduler        = require './scheduler'
TrainTrackerView = require './view/tracker'
TrainStatusView  = require './view/status'
EditorialView    = require './view/editorial'
AdView           = require './view/ads'

EditorialFeed    = require './model/editorial_feed'
TrainStatusFeed  = require './model/train_status_feed'


init = ->
  class Binder extends inject.Binder
    configure: ->
      @bind(Ajax).to(XMLHttpAjax)
      @bindConstant('navigator').to window.navigator
      # TODO(nat):  this 'download-cache' binding is only necessary for the
      # Vistar lib when not running on Cortex, but we still have to bind it to
      # something or it barfs out when injecting dependents
      @bindConstant('download-cache').to {}
      config =
        url:                'http://staging.api.vistarmedia.com/api/v1/get_ad/json'
        apiKey:             '833137c5-1531-48b3-91ae-78167a703bbf'
        networkId:          'gYLccMrITS-5HuSItsmcyQ'
        debug:              true
        width:              1366
        height:             768
        allowAudio:         false
        directConnection:   false
        deviceId:           'testvenue1'
        venueId:            'testvenue1'
        cpm_floor_cents:    30
        min_duration:       7
        max_duration:       8
        latitude:           39.985924
        longitude:          -75.12994
        queueSize:          12
        mimeTypes:          Cortex.player.getMimeTypes()
        displayArea: [
          {
            id:              'display-0'
            width:           1366
            height:          768
            allow_audio:     false
            cpm_floor_cents: 30
          }
        ]

      @bindConstant('config').to config

  injector = new inject.Injector(new Binder)

  cacher = injector.getInstance Cacher

  adView = injector.getInstance AdView

  trainTrackerView = new TrainTrackerView()

  editorialFeed = new EditorialFeed(cacher)
  editorialView = new EditorialView(editorialFeed)

  trainStatusFeed = new TrainStatusFeed()
  trainStatusView = new TrainStatusView(trainStatusFeed)
  schedules = new Array(
    {view: trainTrackerView, duration: 10000},
    {view: adView, alternative: editorialView, duration: 7500},
    {view: editorialView, duration: 6000},
    {view: adView, alternative: editorialView, duration: 7500},
    {view: trainTrackerView, duration: 10000},
    {view: adView, alternative: editorialView, duration: 7500},
    {view: trainStatusView, duration: 10000},
    {view: adView, alternative: editorialView, duration: 7500},
    # this should be Train Line Alerts, which we don't have.
    {view: trainTrackerView, duration: 10000},
    {view: adView, alternative: editorialView, duration: 7500},
    {view: editorialView, duration: 6000},
    {view: adView, alternative: editorialView, duration: 7500},
    {view: trainTrackerView, duration: 10000},
    {view: adView, alternative: editorialView, duration: 7500},
    {view: editorialView, duration: 6000},
    {view: adView, alternative: editorialView, duration: 7500},
    {view: trainTrackerView, duration: 10000},
    {view: adView, alternative: editorialView, duration: 7500},
    {view: trainStatusView, duration: 10000},
    {view: adView, alternative: editorialView, duration: 7500},
    {view: trainTrackerView, duration: 10000},
    {view: adView, alternative: editorialView, duration: 7500},
  )
  '''
  schedules = new Array(
    {view: trainTrackerView, duration: 5000000},
    #{view: trainStatusView, duration: 5000},
    {view: editorialView, duration: 5000000},
  )
  '''
  scheduler = new Scheduler($('#cortex-main'), schedules)
  scheduler.run()


module.exports = init()
