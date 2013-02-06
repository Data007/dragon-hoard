class Manage::Customers::AddressesController < Manage::CustomersController
  before_filter :find_customer
  before_filter :find_address, except: [:new, :create, :index, :edit, :show]

  def new
    @address = @customer.addresses.new
  end

  def create
    @customer.addresses.create params[:address]
    redirect_to edit_manage_customer_path(@customer)
  end

  def destroy
    @address.destroy
    redirect_to edit_manage_customer_path(@customer)
  end

private

  def find_address
    address_id = params[:address_id].present? ? params[:address_id] : params[:id]
    @address = @customer.addresses.find(address_id)
  end
end
