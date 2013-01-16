class Manage::Sales::LineItemsController < Manage::SalesController
  before_filter :get_sale
private
  def get_sale
    @sale = Order.find(params[:sale_id])
  end
end
