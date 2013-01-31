class Manage::QuickSalesController < ManageController
  before_filter :force_pin
  before_filter :find_quick_sale, except: [:new, :create]

  def new
    order = Order.create(staging_type: 'quick_sale')
    redirect_to edit_manage_quick_sale_path(order)
  end

  def cancel
    destroy
  end

  def destroy
    @order.destroy
    redirect_to manage_path
  end

private
  def find_quick_sale
    id = params[:quick_sale_id] ? params[:quick_sale_id] : params[:id]
    @order = Order.find(id)
  end
end
