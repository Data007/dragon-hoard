class ManageController < ApplicationController
  layout 'manage'
  skip_before_filter :current_order
  skip_before_filter :clean_up_order
  before_filter :logout_user, only: [:home]

  def home
  end

private
  def manage_user
    return nil unless session[:manage_user_id]
    @manage_user ||= User.find(session[:manage_user_id])
  end

  def force_pin
    unless manage_user
      # session[:manage_user_id] = User.first.id
      ## Commented out for the sake of demoing
      session[:redirect_to] = request.fullpath
      redirect_to [:new, :manage, :session] 
    end
  end

  def logout_user
    session.delete(:manage_user_id)
  end

  def force_order_has_user
    unless @order.user
      session[:redirect_to] = request.fullpath
      redirect_to [:new, :manage, @order, :user]
    end
  end
end
