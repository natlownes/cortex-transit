FEED = "http://www.transitchicago.com/alerts/routes.aspx"

class TrainStatusFeed
  services: ['Red', 'Blue', 'Brn', 'G', 'Org', 'P', 'Pink', 'Y']
  trainStatus: []

  constructor: ->
    @fetch()
    fetch = ->
      @fetch()

    setInterval(fetch.bind(@), 60 * 1000)

  fetch: ->
    console.log "Fetching train status feed: #{FEED}"
    parse = (data) ->
      @parse data

    try
      window.Cortex.net.get(FEED, {encoding: 'utf8'}).then(parse.bind(@), @error)
    catch e
      @error e

  error: (err) ->
    console.log "Failed to fetch train status feed. ", err

  parse: (data) ->
    xmlDoc = $.parseXML(data)
    xml = $(xmlDoc)
    xmlRecords = xml.find('RouteInfo')
    lines = []
    for record in xmlRecords
      rd = $(record)
      id = rd.find('ServiceId').text()
      if id not in @services
        continue
      route = rd.find('Route').text()
      routeColor = "##{rd.find('RouteColorCode').text()}"
      textColor = "##{rd.find('RouteTextColor').text()}"
      statusColor = "##{rd.find('RouteStatusColor').text()}"
      status = rd.find('RouteStatus').text()

      doc =
        route: route
        routeColor: routeColor
        textColor: textColor
        statusColor: statusColor
        status: status
        id: id

      lines.push doc

    lines.sort (a, b) =>
      ai = @services.indexOf(a)
      bi = @services.indexOf(b)
      if ai < bi
        1
      else if ai > bi
        -1
      else
        0

    if lines.length > 0
      @trainStatus = lines

  getTrainStatus: ->
    if @trainStatus.length == 0
      @fetch()

    @trainStatus

module.exports = TrainStatusFeed
