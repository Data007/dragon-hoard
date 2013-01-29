@itemsToArray = (data) ->
  itemArray = []
  for item in data.items
    itemArray.push "ID#{item.pretty_id} #{item.name}"
  return itemArray

$(document).ready ->
  lineItems = $('.line-item')
  lineItems.each ->

    summary = $(this).find('.line-item-summary')
    summary.data 'storeItems', (items) ->
      summary.data
        'items': items
    summary.data 'getItem', (id) ->
      items = $('.line-item .line-item-summary').data('items')['items']
      foundItem = {}
      for item in items
        if item.pretty_id == parseInt(id)
          foundItem = item
      return foundItem

    summary.autocomplete
      delay: 500
      source: (request, response) ->
        $.getJSON '/manage/live_searches/' + request.term, (data) ->
          summary.data('storeItems')(data)
          dataToArray = itemsToArray(data)
          response dataToArray
      select: (event, ui) ->
        prettyId = ui.item.label.split(' ')[0].replace('ID', '')
        item = summary.data('getItem')(prettyId)
        summary.parent().parent().parent().find('.line-item-price').val(item.price)
