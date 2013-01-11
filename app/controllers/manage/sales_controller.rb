class Manage::SalesController < ManageController
  before_filter :force_access_pin

  def create
    order = Order.create params[:order]
    render json: order.to_json(include: [:line_items]), status: order.created_at? ? '200' : '403'
  end
end
