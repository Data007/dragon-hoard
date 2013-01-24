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
  summary.data 'getItem', (index) ->
    return $('.line-item .line-item-summary').data('items')['items'][index]

  summary.autocomplete
    source: (request, response) ->
      console.log "Sending query #{request.term}"
      $.getJSON '/manage/live_searches/' + request.term, (data) ->
        summary.data('storeItems')(data)
        dataToArray = itemsToArray(data)
        console.log dataToArray
        console.log summary.data('items')
        response dataToArray
