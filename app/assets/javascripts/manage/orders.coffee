@itemsToArray = (data) ->
  itemArray = []
  for item in data.items
    itemArray.push "ID#{item.pretty_id} #{item.name}"
  return itemArray

$(document).ready ->
  $('.line-item .line-item-summary').autocomplete
    source: (request, response) ->
      console.log "Sending query #{request.term}"
      $.getJSON '/manage/live_searches/' + request.term, (data) ->
        response itemsToArray(data)
