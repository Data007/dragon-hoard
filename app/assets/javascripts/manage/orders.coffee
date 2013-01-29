@itemsToArray = (data) ->
  itemArray = []
  for item in data.items
    itemArray.push "ID#{item.pretty_id} #{item.name}"
  return itemArray

$(document).ready ->
  orderId = $('#line-items-view').attr('data-order')
  lineItemForm = $('#line-items-form')
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
    lineItemId = lineItem.attr('data-id')

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

    addItem = lineItem.find('#line-item-add')
    addItem.click (event) ->
      newLineItem = 
        quantity: lineItemForm.find('#line-item-quantity').val()
        summary:  lineItemForm.find('#line-item-summary').val()
        taxable:  lineItemForm.find('#line-item-taxable').val()
        price:    lineItemForm.find('#line-item-price').val()

      $.post "/manage/orders/#{orderId}/line_items/", {line_item: newLineItem}, (data) ->
        console.log data
        newLineItemView = new EJS({url: '/views/manage/orders/line_item'}).render 
          count: $('.line-item').length
          lineItem: data

        $('#line-items-form').before newLineItemView

    deleteItem = lineItem.find('.line-item-delete')
    deleteItem.click (event) ->
      console.log 'like'
      $.ajax 
        url: "/manage/orders/#{orderId}/line_items/#{lineItemId}"
        type: 'DELETE'
      lineItem.remove()

    deleteFormItem = lineItem.find('#line-item-delete')
    deleteFormItem.click (event) ->
      lineItemForm.find('#line-item-quantity').val('1')
      lineItemForm.find('#line-item-summary').val('')
      lineItemForm.find('#line-item-taxable').prop('checked', false)
      lineItemForm.find('#line-item-price').val('')
