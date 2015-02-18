promise = require 'promise'

CortexNet = window.Cortex?.net

FEEDS = [
  "http://kitchen.screenfeed.com/feed/N1_7g9pOxkaEqnDD_EEiog?duration=15",
  "http://kitchen.screenfeed.com/feed/rjn9iSgn8UuNEoqoi5acLw?duration=30",
  "http://kitchen.screenfeed.com/feed/zrNvbmhdd0u9ZvMffjLnQA?take=5&league=NFL&duration=8&view=national"
]

class EditorialFeed
  images: []
  next: undefined

  constructor: (@cacher) ->
    @fetch()
    fetch = ->
      @fetch()
    setInterval(fetch.bind(@), 60 * 1000)

  _promisedDownload: (url, opts) ->
    console.log "Will download feed: #{url}"
    parse = (data) =>
      @parse data
    parse.bind(@)
    new promise (resolve, reject) =>
      CortexNet.download url, opts, (
        (file) =>
          $.get file, (data) =>
            feedImages = parse(data)
            resolve feedImages
      ), reject

  fetch: ->
    opts =
      cache: 60 * 60 * 1000
      stripBom: true
      retry: 3
    allPromises = []
    for feed in FEEDS
      allPromises.push(@_promisedDownload(feed, opts))

    promises = promise.all(allPromises)
    promises.done (
      (results) =>
        allImages = []
        for result in results
          allImages = allImages.concat(result)

        if allImages.length > 0
          @images = allImages
          @getRandom()
    ), (
      (err) =>
        console.log "Failed to fetch editorial feeds.", err
    )

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

    console.log "Feed parsed: Total images found: #{images.length}"
    images

  error: (err) ->
    console.log "Failed to fetch data feed: ", err

  getRandom: ->
    console.log "Total editorial images: #{@images?.length}"
    if not @images? or @images.length == 0
      return null

    if @next?
      current = @next

    else
      current = @images[Math.floor(Math.random() * @images.length)]

    @next = @images[Math.floor(Math.random() * @images.length)]
    @cacher.cacheImage @next

    current

module.exports = EditorialFeed
