class @Order
  constructor: (id) ->
    @orderId = id
    @bindForm()
    @bindActions()
    @bindPrice()
    @bindAmount()
    @totalLineItemForm()
  bindForm: ->
    @form = $('#line-items-form')
    @form.data 'order',
      model:
        id: @orderId
        lineItems: []
      functions:
        totalLineItemForm: @totalLineItemForm
        addLineItem: @addLineItem
  bindActions: ->
    @actions = @form.find('#line-item-actions')
    @actions.append(@addButton())
  bindPrice: ->
    currentOrder = this
    $('#line-item-price').keyup ->
      if this.value.length > 1
        currentOrder.totalLineItemForm()
  bindAmount: ->
    currentOrder = this
    $('#line-item-amount').keyup ->
      currentOrder.totalLineItemForm()
  totalLineItemForm: ->
    price  = $('#line-item-price').val()
    amount = $('#line-item-amount').val()
    total  = accounting.formatMoney(price * amount)
    $('#line-item-total').html(total)
  addLineItem: ->
    form  = $('#line-items-form')
    order = form.data('order').model
    $.post '/manage/sales/' + order.id + '/line_items',
      data:
        item_id: form.find('#line-item-id').val()
        description: form.find('#line-item-description').val()
        price: form.find('#line-item-price').val()
        quantity: form.find('#line-item-amount').val()
      success: (data) ->
        console.log(data)
  addButton: ->
    form = $('#line-items-form')
    button = document.createElement('button')
    button.setAttribute 'class', 'button bg-color-green fg-color-white'
    button.setAttribute 'id', 'line-item-add'
    icon = document.createElement('i')
    icon.setAttribute 'class', 'icon-plus-2'
    button.appendChild icon
    $(button).on 'click', ->
      form.data('order').functions.addLineItem()
    return button
