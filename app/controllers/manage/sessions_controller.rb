class Manage::SessionsController < ManageController
  def create
    session = ApiSession.authorize(params[:pin])

    if session.user
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
  end
end
