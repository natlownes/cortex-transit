inject      = require 'honk-di'

Cortex = window.Cortex

Vistar = require 'vistar-html5player'
Ajax = Vistar.Ajax
XMLHttpAjax = Vistar.XMLHttpAjax

Cacher = require './model/cacher'
AdRequest = require './model/ad_request'
AdService = require './model/ad_service'

Scheduler = require './scheduler'
TrainTrackerView = require './view/tracker'
TrainStatusView = require './view/status'
EditorialView = require './view/editorial'
AdView = require './view/ads'
Player = require './view/ads/player'

EditorialFeed = require './model/editorial_feed'
TrainStatusFeed = require './model/train_status_feed'

init = ->
  class Binder extends inject.Binder
    configure: ->
      @bind(Ajax).to(XMLHttpAjax)
      @bindConstant('navigator').to window.navigator
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
        displayArea: [
          {
            id:              'display-0'
            width:           1366
            height:          768
            allow_audio:     false
            cpm_floor_cents: 30
          }
        ]

      if not Cortex?.player.hasNativeVideoSupport()
        # Desktop version, get ads from a different end point until we
        # fix the mime type problem.
        config.url = 'http://dev.api.vistarmedia.com/api/v1/get_ad/json'
        config.apiKey = 'b5f66eea-98cb-4224-bccf-6324c80cfd08'
        config.networkId = 'sthdw8o-Qm6M2-7V4-VsPw'

      @bindConstant('config').to config

  injector = new inject.Injector(new Binder)

  cacher = injector.getInstance Cacher

  adService = injector.getInstance AdService

  player = new Player()
  adView = new AdView(adService, player)

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
