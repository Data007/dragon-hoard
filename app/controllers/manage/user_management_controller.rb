class Manage::UserManagementController < ApplicationController
  def new
    @user = User.new
    @user.addresses.new
  end

  def index
  end
end
