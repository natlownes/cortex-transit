inject      = require 'honk-di'
Player = require './player'
{
  AdStream
  ProofOfPlay
  Ajax
  XMLHttpAjax
} = require 'vistar-html5player'

Scheduler = require './scheduler'
TrainTrackerView = require './train_tracker_view'
TrainStatusView = require './train_status_view'
EditorialView = require './editorial_view'
AdView = require './ad_view'


init = ->
  class Binder extends inject.Binder
    configure: ->
      @bind(Ajax).to(XMLHttpAjax)
      @bindConstant('navigator').to window.navigator
      @bindConstant('config').to
        url:            'http://dev.api.vistarmedia.com/api/v1/get_ad/json'
        #apiKey:            '385851ce-9d9b-4819-931d-6bf4827e01a7'
        #networkId:         '8kevTrVYThe5mp9saV3LzQ'
        apiKey:            '58b68728-11d4-41ed-964a-95dca7b59abd'
        networkId:         'Ex-f6cCtRcydns8mcQqFWQ'
        debug:             true
        width:             1024
        height:            768
        allowAudio:        false
        directConnection:  false
        deviceId:          'testvenue1'
        venueId:           'testvenue1'
        latitude:          39.9859241
        longitude:         -75.1299363
        queueSize:         12
        displayArea: [
          {
            id:               'display-0'
            width:            1024
            height:           768
            allow_audio:      false
            cpm_floor_cents:  90
          }
        ]

  injector = new inject.Injector(new Binder)

  ads    = injector.getInstance AdStream
  player = injector.getInstance Player
  pop    = injector.getInstance ProofOfPlay

  schedules = new Array(
    {view: new AdView(ads, player, pop), duration: 10000}
    {view: new TrainTrackerView(), duration: 10000}
    {view: new EditorialView(), duration: 10000}
    {view: new TrainStatusView(), duration: 10000}
  )
  scheduler = new Scheduler($('#main'), schedules)
  scheduler.run()

module.exports = init()
