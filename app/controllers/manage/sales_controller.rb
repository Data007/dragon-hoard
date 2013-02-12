class Manage::SalesController < ManageController
  before_filter :force_pin
  before_filter :find_sale, except: [:new, :create]
  before_filter :force_order_has_user, except: [:new, :create]

  def new
    order = Order.create(staging_type: 'sale')
    redirect_to edit_manage_sale_path(order)
  end

  def cancel
    destroy
  end

  def destroy
    @order.destroy
    redirect_to manage_path
  end

private
  def find_sale
    id = params[:sale_id] ? params[:sale_id] : params[:id]
    @order = Order.find(id)
  end
end
