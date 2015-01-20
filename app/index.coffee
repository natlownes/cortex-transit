inject      = require 'honk-di'

vistar = require 'vistar-html5player'
Ajax = vistar.Ajax
XMLHttpAjax = vistar.XMLHttpAjax

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
      @bindConstant('config').to
        url:                'http://dev.api.vistarmedia.com/api/v1/get_ad/json'
        apiKey:             'b5f66eea-98cb-4224-bccf-6324c80cfd08'
        networkId:          'sthdw8o-Qm6M2-7V4-VsPw'
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
  scheduler = new Scheduler($('#cortex-main'), schedules)
  scheduler.run()

module.exports = init()
