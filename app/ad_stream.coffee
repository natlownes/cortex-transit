inject    = require 'honk-di'
Readable  = require('stream').Readable
AdRequest = require './ad_request'


class AdStream extends Readable
  @scope: 'SINGLETON'

  request: inject AdRequest
  config:  inject 'config'

  constructor: ->
    super(objectMode: true)
    setInterval @_check, 15000

  _read: ->
    @emit 'log', name: 'AdStream', message:
      "begin read, buf length #{@_readableState.buffer.length}"
    success = (response) ->
      for ad in (response?.advertisement or [])
        @push(ad)
    @request.fetch().then(success.bind(this)).done()

  _check: =>
    if @_readableState.buffer.length is 0
      @emit 'log', name: 'AdStream', message: 'buffer empty, initiating read'
      @_read()


module.exports = AdStream
