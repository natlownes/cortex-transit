inject        = require 'honk-di'
{XMLHttpAjax} = require './ajax'


class AdRequest

  config: inject 'config'
  http:   inject XMLHttpAjax
  navigator: inject 'navigator'

  url: ->
    "#{@config.scheme}://#{@config.host}#{@config.path}"

  fetch: ->
    @http.request
      type:      'POST'
      url:       @url()
      dataType:  'json'
      data:      JSON.stringify(@body())

  body: ->
    network_id:         @config.networkId
    api_key:            @config.apiKey
    device_id:          @config.deviceId
    number_of_screens:  @config.numberOfScreens
    latitude:           @config.latitude
    longitude:          @config.longitude
    direct_connection:  @config.directConnection
    display_time:       Math.floor(new Date().getTime() / 1000)
    display_area:       @_displayArea()
    device_attribute:   @_deviceAttribute()

  _supportedMedia: ->
    media  = ['image/gif', 'image/jpeg']
    if @_hasMp4()
      media.push 'video/mp4'
    for m in @navigator.mimeTypes
      media.push(m.type)
    media

  _displayArea: ->
    if not @config.displayArea
      throw new Error('must configure a displayArea list')
    for screen in @config.displayArea
      screen.supported_media = @_supportedMedia()
      screen

  _deviceAttribute: -> [
    {
      name: 'UserAgent'
      value: @navigator.userAgent
    }
    {
      name: 'MimeTypes'
      value: @_supportedMedia().join(', ')
    }

  ]

  _hasMp4: ->
    @navigator.userAgent.match(/AppleWebKit/) or
      @navigator.mimeTypes['video/mp4']


module.exports = AdRequest
