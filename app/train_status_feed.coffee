feed = """
<?xml version="1.0" encoding="utf-8"?>
<CTARoutes>
  <TimeStamp>20150113 13:06</TimeStamp>
  <ErrorCode>0</ErrorCode>
  <ErrorMessage/>
  <RouteInfo>
    <Route>Red Line</Route>
    <RouteColorCode>c60c30</RouteColorCode>
    <RouteTextColor>ffffff</RouteTextColor>
    <ServiceId>Red</ServiceId>
    <RouteURL><![CDATA[http://www.transitchicago.com/riding_cta/systemguide/redline.aspx]]></RouteURL>
    <RouteStatus>Normal Service</RouteStatus>
    <RouteStatusColor>404040</RouteStatusColor>
  </RouteInfo>
  <RouteInfo>
    <Route>Blue Line</Route>
    <RouteColorCode>00a1de</RouteColorCode>
    <RouteTextColor>ffffff</RouteTextColor>
    <ServiceId>Blue</ServiceId>
    <RouteURL><![CDATA[http://www.transitchicago.com/riding_cta/systemguide/blueline.aspx]]></RouteURL>
    <RouteStatus>Normal Service</RouteStatus>
    <RouteStatusColor>404040</RouteStatusColor>
  </RouteInfo>
  <RouteInfo>
    <Route>Brown Line</Route>
    <RouteColorCode>62361b</RouteColorCode>
    <RouteTextColor>ffffff</RouteTextColor>
    <ServiceId>Brn</ServiceId>
    <RouteURL><![CDATA[http://www.transitchicago.com/riding_cta/systemguide/brownline.aspx]]></RouteURL>
    <RouteStatus>Normal Service</RouteStatus>
    <RouteStatusColor>404040</RouteStatusColor>
  </RouteInfo>
  <RouteInfo>
    <Route>Green Line</Route>
    <RouteColorCode>009b3a</RouteColorCode>
    <RouteTextColor>ffffff</RouteTextColor>
    <ServiceId>G</ServiceId>
    <RouteURL><![CDATA[http://www.transitchicago.com/riding_cta/systemguide/greenline.aspx]]></RouteURL>
    <RouteStatus>Normal Service</RouteStatus>
    <RouteStatusColor>404040</RouteStatusColor>
  </RouteInfo>
  <RouteInfo>
    <Route>Orange Line</Route>
    <RouteColorCode>f9461c</RouteColorCode>
    <RouteTextColor>ffffff</RouteTextColor>
    <ServiceId>Org</ServiceId>
    <RouteURL><![CDATA[http://www.transitchicago.com/riding_cta/systemguide/orangeline.aspx]]></RouteURL>
    <RouteStatus>Normal Service</RouteStatus>
    <RouteStatusColor>404040</RouteStatusColor>
  </RouteInfo>
  <RouteInfo>
    <Route>Purple Line</Route>
    <RouteColorCode>522398</RouteColorCode>
    <RouteTextColor>ffffff</RouteTextColor>
    <ServiceId>P</ServiceId>
    <RouteURL><![CDATA[http://www.transitchicago.com/riding_cta/systemguide/purpleline.aspx]]></RouteURL>
    <RouteStatus>Normal Service</RouteStatus>
    <RouteStatusColor>404040</RouteStatusColor>
  </RouteInfo>
  <RouteInfo>
    <Route>Purple Line Express</Route>
    <RouteColorCode>522398</RouteColorCode>
    <RouteTextColor>ffffff</RouteTextColor>
    <ServiceId>Pexp</ServiceId>
    <RouteURL><![CDATA[http://www.transitchicago.com/riding_cta/systemguide/purpleline.aspx]]></RouteURL>
    <RouteStatus>Normal Service</RouteStatus>
    <RouteStatusColor>404040</RouteStatusColor>
  </RouteInfo>
  <RouteInfo>
    <Route>Pink Line</Route>
    <RouteColorCode>e27ea6</RouteColorCode>
    <RouteTextColor>ffffff</RouteTextColor>
    <ServiceId>Pink</ServiceId>
    <RouteURL><![CDATA[http://www.transitchicago.com/riding_cta/systemguide/pinkline.aspx]]></RouteURL>
    <RouteStatus>Normal Service</RouteStatus>
    <RouteStatusColor>404040</RouteStatusColor>
  </RouteInfo>
  <RouteInfo>
    <Route>Yellow Line</Route>
    <RouteColorCode>f9e300</RouteColorCode>
    <RouteTextColor>000000</RouteTextColor>
    <ServiceId>Y</ServiceId>
    <RouteURL><![CDATA[http://www.transitchicago.com/riding_cta/systemguide/yellowline.aspx]]></RouteURL>
    <RouteStatus>Normal Service</RouteStatus>
    <RouteStatusColor>404040</RouteStatusColor>
  </RouteInfo>
</CTARoutes>
"""

class TrainStatusFeed
  services: ['Red', 'Blue', 'Brn', 'G', 'Org', 'P', 'Pink', 'Y']

  constructor: ->
    xmlDoc = $.parseXML(feed)
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

    @trainStatus = lines

  getTrainStatus: ->
    @trainStatus

module.exports = TrainStatusFeed
