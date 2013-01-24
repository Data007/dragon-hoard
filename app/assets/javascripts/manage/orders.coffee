class @Order
  constructor: (id) ->
    @orderId = id
    @bindForm()
    @bindActions()
    @bindData()
  bindForm: ->
    @form = $('#line-items-form')
    @form.data 'order',
      model:
        id: @orderId
        lineItems: []
      totalLineItemForm: @totalLineItemForm
      addLineItem: @addLineItem
      clearLineItems: @clearLineItems
      refreshLineItemView: @refreshLineItemView
      renderLineItemView: @renderLineItemView
  bindActions: ->
    @actions = @form.find('#line-item-actions')
    @actions.find('#line-item-add').on 'click', ->
      @form.data('order').addLineItem()
  bindData: ->
    form = $('#line-items-form')
    form.data('order').clearLineItems()
    $('.line-item').each ->
      lineItem =
        summary: $(this).find('.line-item-summary').val()
        taxable: $(this).find('.line-item-taxable').val()
        price: $(this).find('.line-item-price').val()
        quantity: $(this).find('.line-item-quantity').val()
      form.data('order').model.lineItems.push lineItem
  clearLineItems: ->
    $('#line-items-form').data('order').model.lineItems = []
  addLineItem: ->
    form  = $('#line-items-form')
    order = form.data('order').model
    item_id = form.find('#line-item-id')
    description = form.find('#line-item-description')
    price = form.find('#line-item-price')
    quantity = form.find('#line-item-amount')
    data  =
      line_item:
        item_id: item_id.val()
        description: description.val()
        price: price.val()
        quantity: quantity.val()
    $.ajax(url: '/manage/sales/' + order.id + '/line_items', data: data, type: 'POST')
    order.lineItems.push(data.line_item)
    form.data('order').refreshLineItemView()
    item_id.val('')
    description.val('')
    price.val('')
    quantity.val('')
  refreshLineItemView: ->
    form = $('#line-items-form')
    $('.line-item').remove()
    $(form.data('order').model.lineItems).each ->
      form.before form.data('order').renderLineItemView(this)
  renderLineItemView: (lineItem) ->
    count = $('.line-item').count + 1
    view  = new EJS({url: '/views/manage/orders/line_item'}).render({count: count, lineItem: lineItem})
    return view
  deleteLineItem: (selector) ->
    $(selector)
  deleteButton: (selector) ->
    form = $('#line-items-form')
    button = document.createElement('button')
    button.setAttribute 'class', 'button bg-color-green fg-color-white'
    button.setAttribute 'id', 'line-item-delete'
    icon = document.createElement('i')
    icon.setAttribute 'class', 'icon-plus-2'
    button.appendChild icon
    $(button).on 'click', ->
      form.data('order').deleteLineItem(selector)
    return button

