@itemsToArray = (data) ->
  itemArray = []
  for item in data.items
    itemArray.push "ID#{item.pretty_id} #{item.name}"
  return itemArray

@clearLineItemForm = () ->
  $('#line-items-form #line-item-quantity').val('1')
  $('#line-items-form #line-item-summary').val('')
  $('#line-items-form #line-item-taxable').prop('checked', false)
  $('#line-items-form #line-item-price').val('')
  $('#line-items-form #line-item-note').val('')

@subTotalOrder = () ->
  total = 0.0
  $('.line-item.active').each ->
    price = parseFloat($(this).find('.line-item-price').val())
    quantity = parseFloat($(this).find('.line-item-quantity').val())
    total += parseFloat(price * quantity)
  return total

@taxOrder = () ->
  tax = 0.0
  $('.line-item.active .line-item-taxable:checked').each ->
    lineItem = $(this).parent().parent().parent()
    price = parseFloat(lineItem.find('.line-item-price').val())
    quantity = parseFloat(lineItem.find('.line-item-quantity').val())

    tax += parseFloat((price * quantity) * 0.06)
  return tax

@totalOrder = () ->
  return parseFloat(subTotalOrder() + taxOrder())

@refreshTotals = () ->
  $('#subtotal').text accounting.formatMoney(subTotalOrder())
  $('#tax').text accounting.formatMoney(taxOrder())
  $('#total').text accounting.formatMoney(totalOrder())

@autoSaveLineItems = () ->
  orderId = $('#line-items-view').attr('data-order')
  $('.line-item.active').each ->
    lineItem = $(this)
    lineItem.find('.line-item-quantity').keyup ->
      if $(this).attr('data-value') != $(this).val()
        $.ajax
          url: "/manage/orders/#{orderId}/line_items/#{lineItem.attr('data-id')}"
          type: 'PUT'
          data: 
            line_item: 
              quantity: $(this).val()
        $(this).attr('data-value', $(this).val())
        bindLineItem $(this)
    lineItem.find('.line-item-summary').keyup ->
      if $(this).attr('data-value') != $(this).val()
        $.ajax
          url: "/manage/orders/#{orderId}/line_items/#{lineItem.attr('data-id')}"
          type: 'PUT'
          data: 
            line_item: 
              summary: $(this).val()
        $(this).attr('data-value', $(this).val())
        bindLineItem $(this)
    lineItem.find('.line-item-taxable').click ->
      $.ajax
        url: "/manage/orders/#{orderId}/line_items/#{lineItem.attr('data-id')}"
        type: 'PUT'
        data: 
          line_item: 
            taxable: ($(this).prop('checked') ? true : false)
      $(this).attr('data-value', $(this).val())
      bindLineItem $(this)
    lineItem.find('.line-item-price').keyup ->
      if $(this).attr('data-value') != $(this).val()
        $.ajax
          url: "/manage/orders/#{orderId}/line_items/#{lineItem.attr('data-id')}"
          type: 'PUT'
          data: 
            line_item: 
              price: $(this).val()
        $(this).attr('data-value', $(this).val())
        bindLineItem $(this)
    lineItem.find('.line-item-note').keyup ->
      if $(this).attr('data-value') != $(this).val()
        $.ajax
          url: "/manage/orders/#{orderId}/line_items/#{lineItem.attr('data-id')}"
          type: 'PUT'
          data: 
            line_item: 
              note: $(this).val()
        $(this).attr('data-value', $(this).val())
        bindLineItem $(this)

@bindLineItem = (lineItem) ->
  orderId = $('#line-items-view').attr('data-order')
  lineItemForm = $('#line-items-form')
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

  if lineItem.find('.line-item-note').val() != ''
    lineItem.find('.line-item-note-view').show()

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
      taxable:  lineItemForm.find('#line-item-taxable:checked').val()
      price:    lineItemForm.find('#line-item-price').val()
      note:     lineItemForm.find('#line-item-note')[0].value

    $.post "/manage/orders/#{orderId}/line_items/", {line_item: newLineItem}, (data) ->
      newLineItemView = new EJS({url: '/views/manage/orders/line_item'}).render 
        count: $('.line-item').length
        lineItem: data

      $('#line-items-form').before newLineItemView
      clearLineItemForm()
      lineItemLength = $('.line-item').length
      bindLineItem $($('.line-item')[lineItemLength - 2])

  deleteItem = lineItem.find('.line-item-delete')
  deleteItem.click (event) ->
    $.ajax 
      url: "/manage/orders/#{orderId}/line_items/#{lineItemId}"
      type: 'DELETE'
    lineItem.remove()

  deleteFormItem = lineItem.find('#line-item-delete')
  deleteFormItem.click (event) ->
    clearLineItemForm()

  addNote = lineItem.find('.line-item-note-button')
  addNote.click (event) ->
    noteArea = lineItem.find('.line-item-note-view')
    noteArea.show()
    noteArea.find('.line-item-note').focus()

  refreshTotals()
  autoSaveLineItems()

@refreshLineItems = () ->
  lineItems = $('.line-item')
  lineItems.each ->
    lineItem = $(this)
    bindLineItem lineItem

$(document).ready ->
  refreshLineItems()
