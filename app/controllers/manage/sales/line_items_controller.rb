class Manage::Sales::LineItemsController < Manage::SalesController
  skip_filter :force_pin
  before_filter :find_sale

  def create
    line_item = @sale.line_items.create(params[:line_item])
    render json: line_item.to_json
  end

  def destroy
    @sale.line_items.find(params[:id]).destroy
    render json: {message: 'Line item removed'}.to_json
  end
end
