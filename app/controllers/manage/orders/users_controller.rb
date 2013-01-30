class Manage::Orders::UsersController < Manage::OrdersController

  def new
  end

  def find
    @users = User.where(first_name: params[:query])
  end

  def show
    user = User.find(params[:id])
    @order.user = user
    @order.save
    redirect_to edit_manage_sale_path(@order.id)
  end
end
