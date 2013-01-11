class Manage::Sales::LineItemsController < Manage::SalesController
  before_filter :force_access_pin
  before_filter :get_sale

  def create
    line_item = @sale.line_items.create params[:line_item]
    if line_item.valid?
      render json: @sale.to_json(include: [:line_items]), status: '200'
    else
      render json: {message: 'Validation error.', errors: line_item.errors}.to_json, status: '403'
    end
  end

  def update
    line_item = @sale.line_items.find params[:id]
    if line_item.update_attributes params[:line_item]
      render json: line_item, status: '200'
    else
      render json: {message: 'Updating error.', errors: line_item.errors}.to_json, status: '403'
    end
  end

private
  def get_sale
    @sale = Order.where(pretty_id: params[:sale_id]).first
    # @sale = Order.find(params[:sale_id])
  end
end
