inject        = require 'honk-di'
{Transform}   = require('stream')
{XMLHttpAjax} = require './ajax'


class ProofOfPlay extends Transform
  @scope: 'SINGLETON'

  http:    inject XMLHttpAjax
  config:  inject 'config'

  constructor: ->
    super(objectMode: true)

  expire: (ad) ->
    @emit 'log', name: 'ProofOfPlay', message: 'expiring', meta: ad
    url = ad.expiration_url
    req = @http.request
      type: 'GET'
      url:  url
    req.then (response) -> JSON.parse(response)

  confirm: (ad) ->
    @emit 'log', name: 'ProofOfPlay', message: 'confirming', meta: ad
    url = ad.proof_of_play_url
    req = @http.request
      type: 'POST'
      url:  url
      data: JSON.stringify(display_time: ad.display_time)
    req.then (response) -> JSON.parse(response)

  _transform: (ad, encoding, callback) ->
    if @_wasDisplayed(ad)
      @confirm(ad).then (response) ->
        callback(null, response)
    else
      @expire(ad).then (response) ->
        callback(null, response)

  _wasDisplayed: (ad) ->
    ad.html5player?.was_played


module.exports = ProofOfPlay
