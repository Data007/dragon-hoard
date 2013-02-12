class Manage::CustomersController < ManageController
  before_filter :find_customer, except: [:new, :create, :index, :find]
  
  def new
    @customer = User.new
    @customer.addresses.build
    @customer.phones.build
  end

  def create
    @customer = User.create(params[:user])
    redirect_to edit_manage_customer_path(@customer)
  end
  
  def index
    @customers = User.customers.paginate(pagination_hash.merge(order: 'last_name ASC'))
  end

  def find
    @customers = User.find_from_query(params[:query])
    render template: 'manage/customers/index'
  end

  def update
    if @customer.update_attributes params[:user]
      redirect_to edit_manage_customer_path(@customer), flash: {notice: "Your changes have been saved"}
    else
      flash[:error] = 'There was a problem updating the customer'
      render template: 'manage/customers/edit'
    end
  end

  def destroy
    @customer.destroy
    redirect_to manage_customers_path, flash: {notice: "User has been deleted"}
  end

private
  def find_customer
    customer_id = params[:customer_id].present? ? params[:customer_id] : params[:id]
    @customer = User.find(customer_id)
  end
end
