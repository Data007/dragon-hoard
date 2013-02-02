class Manage::UsersController < ApplicationController
  
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

  end
end
