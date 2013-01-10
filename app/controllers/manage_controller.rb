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
    if params[:format] == 'js'
      session = ApiSession.where(token: params[:token]).first
      if session
        render json: {
          user: {
            first_name: session.user.first_name,
            last_name: session.user.first_name,
            full_name: session.user.full_name,
            email: session.user.email,
            id: session.user.id
          },
          token: session.token,
          created_at: session.created_at
        }.to_json
      else
        render json: {message: 'Unauthorized. You must provide a valid pin to access this feature.'}.to_json, status: 401
      end
    else
      unless manage_user
        session[:redirect_to] = request.url
        redirect_to [:manage, :authorize]
      end
    end
  end
end
