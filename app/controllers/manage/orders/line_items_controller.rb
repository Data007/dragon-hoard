class Manage::Orders::LineItemsController < Manage::OrdersController
  skip_filter :force_pin
  before_filter :find_order
  before_filter :find_line_item, except: [:new, :create]

  def create
    line_item = @order.line_items.create(params[:line_item])
    render json: line_item.to_json
  end

  def destroy
    @line_item.destroy
    render json: {message: 'Line item removed'}.to_json
  end

  def update
    @line_item.update_attributes params[:line_item]
    render json: @line_item.to_json
  end

private
  def find_line_item
    @line_item = @order.line_items.find(params[:id])
  end
end
