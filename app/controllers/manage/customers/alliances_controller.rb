class Manage::Customers::AlliancesController < Manage::CustomersController
  before_filter :find_customer

  def find
  end

  def select
    @ally = Alliance.new(ally_id: params[:id])
  end

  def new
    @users = User.find_from_query(params[:query])
  end

  def create
    @customer.add_alliance(params[:alliance])
    redirect_to edit_manage_customer_path(@customer)
  end
end
