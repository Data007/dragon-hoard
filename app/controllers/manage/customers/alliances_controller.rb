class Manage::Customers::AlliancesController < Manage::CustomersController
  before_filter :find_customer
  before_filter :find_alliance, only: [:destroy]

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

  def destroy
    @alliance.destroy
    redirect_to edit_manage_customer_path(@customer)
  end

private
  def find_alliance
    alliance_id = params[:alliance_id].present? ? params[:alliance_id] : params[:id]
    @alliance = @customer.alliances.find(alliance_id)
  end
end
