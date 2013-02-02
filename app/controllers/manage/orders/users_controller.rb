class Manage::Orders::UsersController < Manage::OrdersController

  def new
  end

  def find
    @users = User.find_from_query(params[:query])
  end

  def show
    user = User.find(params[:id])
    @order.user = user
    @order.address = user.addresses.first if user.addresses.present?
    @order.save
    redirect_to edit_manage_sale_path(@order.id)
  end
end
