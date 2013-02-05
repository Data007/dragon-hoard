class Manage::Customers::FingersController < Manage::CustomersController
  before_filter :find_customer
  def new
    @finger = @customer.fingers.new
  end

  def create
    @customer.fingers.create params[:finger]
    redirect_to edit_manage_customer_path(@customer)
  end 
end
