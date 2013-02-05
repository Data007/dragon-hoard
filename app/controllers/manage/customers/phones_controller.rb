class Manage::Customers::PhonesController < Manage::CustomersController
  before_filter :find_customer
  before_filter :find_phone, except: [:new, :create, :index, :edit, :show]
  def new
    @phone = @customer.phones.new
  end

  def create
    @customer.phones.create params[:phone]
    redirect_to edit_manage_customer_path(@customer) 
  end

  def destroy
    @phone.destroy
    redirect_to edit_manage_customer_path(@customer)
  end

private
  def find_phone
    phone_id = params[:phone_id].present? ? params[:phone_id] : params[:id]
    @phone = Phone.find(phone_id)
  end
end
