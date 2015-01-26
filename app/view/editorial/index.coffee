moment = require 'moment'

View = require '../index'

class EditorialView extends View
  constructor: (@feed) ->

  stop: ->

  render: (node) ->
    img = @feed.getRandom()
    if img?
      html = """
      <div class="editorial"
        style="background: url(#{img}) no-repeat center center fixed;">
      </div>
      """

      node.html(html)
      true

    else
      false

module.exports = EditorialView
