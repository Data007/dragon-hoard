class @Order
  constructor: ->
    @bindForm()
    @bindActions()
    @bindPrice()
    @bindAmount()
    @totalLineItemForm()
  bindForm: ->
    @form = $('#line-items-form')
  bindActions: ->
    @actions = @form.find('#line-item-actions')
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
    total  = accounting.formatMoney(price + amount)
    $('#line-item-total').html(total)
    
@order = new @Order
