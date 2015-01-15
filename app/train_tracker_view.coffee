moment = require 'moment'
View = require './view'
WeatherView = require './weather_view'

class TrainFeed
  rtt: 11 # cycle every 11mins
  routes: [
    {route: 'Red Line #901', direction: '95th/Dan Ryan', diff: 0} # 0, 11, 22, ...
    {route: 'Red Line #904', direction: 'Howard', diff: 4} # 4, 15, 26, ...
    {route: 'Red Line #820', direction: 'Howard', diff: 9}
    {route: 'Red Line #902', direction: '95th/Dan Ryan', diff: 10}
  ]
  
  getCurrentSchedule: ->
    min = moment().minute()
    routes = []
    for r in @routes
      diff = r.diff
      due = (@rtt - ((min - diff) % @rtt)) % @rtt
      routes.push route: r.route, direction: r.direction, due: due

    routes.sort (a, b) ->
      if a.due > b.due
        1
      else if a.due < b.due
        -1
      else
        0

    for r in routes
      if r.due == 0
        r.arrival = 'Due'
      else
        r.arrival = "#{r.due} min"

    stop: 'Berwyn'
    routes: routes

class TrainTrackerView extends View
  constructor: ->
    @trainFeed = new TrainFeed()

  stop: ->

  render: (node) ->
    html = """
    <div class="tracker container-fluid">
    <div class="row">
      <div class="col-xs-12">
        <div class="header">
          <h1>
            <img class="logo" src="./cta-logo.svg" />
            <span class="brand">cta</span> <span class="brand-sub">train tracker<sup>sm</sup></span>
            <span class="title">estimated arrivals</span>
          </h1>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-xs-12">
        <table width="100%" class="table">
        <tbody>
          <tr>
            <td class="widget" valign="top">
              #{@renderTransitWidget()}
            </td>
            <td class="weather-widget" valign="top">
              <div id="weather"></div>
            </td>
          </tr>
        </tbody>
        </table>
      </div>
    </div>
    </div> <!-- container-fluid -->
    """
    node.html(html)
    w = new WeatherView()
    w.render($('#weather'))

  renderTransitWidget: ->
    schedule = @trainFeed.getCurrentSchedule()
    html = """
    <table width="100%">
      <tr>
        <td valign="top">
          <div class="stop">#{schedule.stop}</div>
        </td>
      </tr>
    """
    for route in schedule.routes
      html = html + """
      <tr>
        <td valign="top">
          <div class="route">
            <div class="due pull-right">
              #{route.arrival}
            </div>
            <div class="line-name">
              #{route.route}
            </div>
            <div class="direction">
              #{route.direction}
            </div>
          </div>
        </td>
      </tr>
      """
    html = html + """
    </table>
    """

module.exports = TrainTrackerView
