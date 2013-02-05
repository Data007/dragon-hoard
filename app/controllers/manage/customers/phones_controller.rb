class Manage::Customers::PhonesController < Manage::CustomersController
  before_filter :find_customer
  def new
    @phone = @customer.phones.new
  end

  def create
    @customer.phones.create params[:phone]
    redirect_to edit_manage_customer_path(@customer) 
  end

  def destory
    binding.pry
  end
end
