class ManageController < ApplicationController
  layout 'manage'
  skip_before_filter :current_order
  skip_before_filter :clean_up_order

  def home
  end

private
  def manage_user
    return nil unless session[:manage_user_id]
    @manage_user ||= User.find(session[:manage_user_id])
  end

  def force_pin
    unless manage_user
      session[:redirect_to] = request.fullpath
      redirect_to [:new, :manage, :session] 
    end
  end
end
