promise = require 'promise'

FEEDS = [
  "http://kitchen.screenfeed.com/feed/N1_7g9pOxkaEqnDD_EEiog?duration=15",
  "http://kitchen.screenfeed.com/feed/rjn9iSgn8UuNEoqoi5acLw?duration=30",
  "http://kitchen.screenfeed.com/feed/zrNvbmhdd0u9ZvMffjLnQA?take=5&league=NFL&duration=8&view=national"
]

class EditorialFeed
  images: []

  constructor: ->
    @fetch()
    fetch = ->
      @fetch()
    setInterval(fetch.bind(@), 15 * 60 * 1000)

  _fetchOne: (feed) ->
    window.Cortex.net.get(feed, encoding: 'utf8')

  fetch: ->
    promises = promise.all(FEEDS.map(@_fetchOne))
    promises.done ((results) =>
      allImages = []
      for result in results
        images = @parse result
        allImages = allImages.concat(images)

      @images = allImages
    ), @error

  parse: (data) ->
    xmlDoc = $.parseXML(data)
    xml = $(xmlDoc)
    items = xml.find('item')
    images = []
    for item in items
      item = $(item)
      img = item.find('media\\:content, content')
      url = img.attr('url')
      images.push url

    images

  error: (err) ->
    console.log "Failed to fetch data feed: ", err

  getRandom: ->
    @images[Math.floor(Math.random() * @images.length)]

module.exports = EditorialFeed
