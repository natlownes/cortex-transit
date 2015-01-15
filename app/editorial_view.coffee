moment = require 'moment'

View = require './view'
EditorialFeed = require './editorial_feed'

class EditorialView extends View
  constructor: ->
    @editorialFeed = new EditorialFeed()

  stop: ->

  render: (node) ->
    img = @editorialFeed.getRandom()
    html = """
    <div class="editorial-container"
      style="background: url(#{img}) no-repeat center center fixed; -webkit-background-size:contain">
    </div>
    """

    node.html(html)

module.exports = EditorialView
