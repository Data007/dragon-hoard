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

  def force_access_pin
    session = ApiSession.where(token: params[:token]).first
    unless session
      render json: {message: 'Unauthorized. You must provide a valid token to access this feature.'}.to_json, status: 401
    end
  end
end
