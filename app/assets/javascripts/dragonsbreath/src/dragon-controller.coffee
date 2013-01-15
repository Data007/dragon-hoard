class @DragonController
  events: ->
    click:
      selector: '.selector'
      function: 'clicked'
  constructor: ->
    @bindEvents()

  bindEvents: ->
    for event, details of @events()
      console.log event
      console.log(`details.function`)
      $(details.selector).bind event, (event) ->
        # TODO: needs to chain up to the root that we've been bound to
        eval('app.dragonController.' + details.function + '()')
  clicked: ->
    alert 'boo'
