class Manage::OrdersController < ManageController
  before_filter :force_pin
  before_filter :find_order

private
  def find_order
    id = params[:order_id] ? params[:order_id] : params[:id]
    @order = Order.find(id)
  end
end
