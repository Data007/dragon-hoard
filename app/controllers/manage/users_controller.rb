class Manage::UsersController < ApplicationController
  before_filter :find_customer, except: [:new, :create, :index]
  
  def new
    @customer = User.new
    @customer.addresses.new
    @customer.phones.new
  end

  def create
    @customer = User.create(params[:user])
    redirect_to manage_users_path
  end
  
  def index
    @customers = User.where(role: 'customer')
  end

  def edit
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
    customer_id = params[:id].present? ? params[:id] : params[:user]
    @customer = User.find(customer_id)
  end
end
