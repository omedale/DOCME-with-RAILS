class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:login_user, :register]

  def login_user
    authenticate params[:email], params[:password]
  end

  def register
    @user = User.create!(name: params[:name], email: params[:email], password: params[:password], role_id: 1)
    if(@user.save)
      return json_response(@user, :created)
    end
    return json_response(@user.errors, :created)
  end

  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)
  
    if command.success?
      render json: { auth_token: command.result }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

  private def user_params
    params.require(:user).permit(:name, :password, :email)
  end
end
