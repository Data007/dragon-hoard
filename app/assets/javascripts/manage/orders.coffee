class @Order
  constructor: (id) ->
    @orderId = id
    @bindForm()
    @bindActions()
    @bindPrice()
    @bindAmount()
    @bindData()
    @totalLineItemForm()
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
  bindData: ->
    form = $('#line-items-form')
    form.data('order').clearLineItems()
    $('.line-item').each ->
      lineItem =
        item_id: $(this).find('.line-item-id').val()
        description: $(this).find('.line-item-description').val()
        price: $(this).find('.line-item-price').val()
        quantity: $(this).find('.line-item-amount').val()
      form.data('order').model.lineItems.push lineItem
  clearLineItems: ->
    $('#line-items-form').data('order').model.lineItems = []
  totalLineItemForm: ->
    price  = $('#line-item-price').val()
    amount = $('#line-item-amount').val()
    total  = accounting.formatMoney(price * amount)
    $('#line-item-total').html(total)
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
    view  = "
        <tr class='line-item' id='line-item-" + count + "'>
          <td>
            <div class='input-control text'>
              <input type='text' name='line_item[item_id]' placeholder='ID...' value='" + lineItem.item_id + "'class='line-item-id' />
              <button class='helper'></button>
            </div>
          </td>
          <td>
            <div class='input-control textarea'>
              <textarea name='line_item[description]' placeholder='Something prett made in your store ...' class='line-item-description'>" + lineItem.description + "</textarea>
            </div>
          </td>
          <td>
            <div class='input-control text'>
              <input type='text' name='line_item[price]' placeholder='3500.00' value='" + lineItem.price + "'class='line-item-price' />
              <button class='helper'></button>
            </div>
          </td>
          <td>
            <div class='input-control text'>
              <input type='text' name='line_item[quantity]' placeholder='1' value='" + lineItem.quantity + "'class='line-item-amount' />
              <button class='helper'></button>
            </div>
          </td>
          <td>
            <span class='line-item-total'>&nbsp;</span>
          </td>
          <td class='line-item-actions toolbar'>&nbsp;</td>
        </tr>
      "
    return view
  deleteLineItem: (selector) ->
    $(selector)
  addButton: ->
    form = $('#line-items-form')
    button = document.createElement('button')
    button.setAttribute 'class', 'button bg-color-green fg-color-white'
    button.setAttribute 'id', 'line-item-add'
    icon = document.createElement('i')
    icon.setAttribute 'class', 'icon-plus-2'
    button.appendChild icon
    $(button).on 'click', ->
      form.data('order').addLineItem()
    return button
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

