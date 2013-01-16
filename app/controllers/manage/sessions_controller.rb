class Manage::SessionsController < ManageController
  def create
    user = User.where(pin: params[:user][:pin]).first
    if user
      session[:manage_user_id] = user.id
      redirect_to session[:redirect_to]
    else
      redirect_to [:new, :manage, :session], flash: {error: 'Unauthorized. Your pin is incorrect'}
    end
  end
end
