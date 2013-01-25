@itemsToArray = (data) ->
  itemArray = []
  for item in data.items
    itemArray.push "ID#{item.pretty_id} #{item.name}"
  return itemArray

$(document).ready ->
  summary = $('.line-item .line-item-summary')
  summary.data 'storeItems', (items) ->
    summary.data
      'items': items
  summary.data 'getItem', (id) ->
    items = $('.line-item .line-item-summary').data('items')['items']
    console.log "Getting item with a pretty id of #{id}"
    console.log items
    foundItem = {}
    for item in items
      console.log item.pretty_id
      console.log item.pretty_id == parseInt(id)
      if item.pretty_id == parseInt(id)
        foundItem = item
    return foundItem

  summary.autocomplete
    delay: 500
    source: (request, response) ->
      console.log "Sending query #{request.term}"
      $.getJSON '/manage/live_searches/' + request.term, (data) ->
        summary.data('storeItems')(data)
        dataToArray = itemsToArray(data)
        response dataToArray
    select: (event, ui) ->
      console.log "#{ui.item.label}, index #{ui.item.value}, selected"
      console.log summary.data('getItem')(ui.item.value)
      prettyId = ui.item.label.split(' ')[0].replace('ID', '')
      item = summary.data('getItem')(prettyId)
      summary.parent().parent().parent().find('.line-item-price').val(item.price)
      console.log item

