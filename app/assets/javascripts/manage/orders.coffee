@itemsToArray = (data) ->
  itemArray = []
  for item in data.items
    itemArray.push "ID#{item.pretty_id} #{item.name}"
  return itemArray

$(document).ready ->
  lineItems = $('.line-item')
  lineItems.each ->
    lineItem = $(this)
    lineItem.data 'storeItems', (items) ->
      lineItem.data
        'items': items
    lineItem.data 'getItem', (id) ->
      items = lineItem.data('items')['items']
      foundItem = {}
      for item in items
        if item.pretty_id == parseInt(id)
          foundItem = item
      return foundItem

    addLineItem = lineItem.find('#item-add')

    summary = lineItem.find('.line-item-summary')
    summary.autocomplete
      delay: 500
      source: (request, response) ->
        $.getJSON '/manage/live_searches/' + request.term, (data) ->
          lineItem.data('storeItems')(data)
          dataToArray = itemsToArray(data)
          response dataToArray
      select: (event, ui) ->
        prettyId = ui.item.label.split(' ')[0].replace('ID', '')
        item = lineItem.data('getItem')(prettyId)
        lineItem.find('.line-item-price').val(item.price)
