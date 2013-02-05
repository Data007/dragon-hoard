class Manage::UsersController < ManageController
  before_filter :find_customer, except: [:new, :create, :index, :find]
  
  def new
    @customer = User.new
    @customer.addresses.build
    @customer.phones.build
  end

  def create
    @customer = User.create(params[:user])
    redirect_to manage_users_path
  end
  
  def index
    @customers = User.all.paginate(pagination_hash.merge(order: 'last_name ASC'))
  end

  def find
    @customers = User.find_from_query(params[:query])
    render template: 'manage/users/index'
  end

  def edit
    @customer.addresses.build
    @customer.phones.build
  end

  def update
    @customer.update_attributes params[:user]
    redirect_to manage_users_path, flash: {notice: "Your changes have been saved"}
  end

  def destroy
    @customer.destroy
    redirect_to manage_users_path, flash: {notice: "User has been deleted"}
  end

private
  def find_customer
    customer_id = params[:user_id].present? ? params[:user_id] : params[:id]
    @customer = User.find(customer_id)
  end
end
