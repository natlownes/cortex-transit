moment = require 'moment'

View = require '../index'

CHICAGO_WEATHER_FEED = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22chicago%2C%20il%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"

class WeatherView extends View
  render: (node) ->
    @updateWeatherWidget node
    true

  updateWeatherWidget: (node) ->
    $.get(CHICAGO_WEATHER_FEED, (
      (data) =>
        if data?.query?.results?.channel?.item?.condition?
          condition = data.query.results.channel.item.condition
          temp = condition.temp
          text = condition.text
          now = moment()
          hour = now.format('h:mm')
          ampm = now.format('a')
          dayOfWeek = now.format('dddd')
          dayOfMonth = now.format('MMMM D')

          html = """
          <div class="row>
            <div class="col-xs-12">
              <div class="text-right hour">#{hour}</div>
              <div class="text-right ampm">#{ampm}</div>
              <div class="text-right day-of-week">#{dayOfWeek}</div>
              <div class="text-right day-of-month">#{dayOfMonth}</div>
              <div class="text-right weather-icon">
                <i class="wi wi-day-cloudy"></i>
              </div>
              <div class="text-right temperature">
                #{temp}&deg;F
              </div>
            </div>
          </div>
          """
          node.html(html)
      )
    )

module.exports = WeatherView
