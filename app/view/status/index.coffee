moment = require 'moment'

View = require '../index'
WeatherView = require '../weather'

class TrainStatusView extends View
  constructor: (@feed)->

  stop: ->

  render: (node) ->
    trainStatus = @feed.getTrainStatus()
    if not trainStatus? or trainStatus.length == 0
      return false

    html = """
    <div class="status container-fluid">
    <div class="row">
      <div class="col-xs-12">
        <div class="header">
          <i class="fa fa-info-circle"></i> Rail ('L') system status
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-xs-12">
        <table width="100%" class="table widget-container">
        <tbody>
          <tr>
            <td class="widget" valign="top">
              #{@renderStatusWidget(trainStatus)}
            </td>
            <td class="weather-widget" valign="top">
              <div class="weather"></div>
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
    w.render($('.weather-widget .weather'))

  renderStatusWidget: (trainStatus) ->
    html = """
    <table width="100%" class="table line-table">
    <tbody>
    """
    for line in trainStatus
      html = html + """
      <tr>
        <td valign="top">
          <table width="100%" class="status-table">
          <tbody>
            <tr>
              <td width="30%" style="background-color: #{line.routeColor}; color: #{line.textColor}" >
                <span class="line-name">#{line.route}</span>
              </td>
              <td width="70%" style="background-color: #363636; color: #f3f3f3" >
                <span class="line-status">#{line.status}</span>
              </td>
            </tr>
          </tbody>
          </table>
        </td>
      </tr>
      """

    html = html + """
    </tbody>
    </table>
    """
    html

module.exports = TrainStatusView
