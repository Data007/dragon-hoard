class Manage::Orders::UsersController < Manage::OrdersController

  def new
  end

  def find
    @users = User.where(first_name: params[:query])
  end
end
