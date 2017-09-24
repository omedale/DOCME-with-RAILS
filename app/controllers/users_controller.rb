class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:login_user, :register]

  def login_user
    authenticate params[:email], params[:password]
  end

  def register
    @user = User.create!(name: params[:name], email: params[:email], password: params[:password], role_id: 2)
    if(@user.save)
      command = AuthenticateUser.call(params[:email], params[:password])
      if command.success?
        obj = {
          auth_token: command.result,
          name: @user.name,
          email: @user.email,
          role_id: @user.role_id,
          message: 'User Created Succefully and Logged in'
        }
        return json_response(obj, :created)
      else
        render json: { error: command.errors }, status: :unauthorized
      end
    end
    return json_response(@user.errors, :created)
  end

  private

  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)
  
    if command.success?
      render json: {
        auth_token: command.result,
        message: 'User Succefully Logged in' 
      }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

  def user_params
    params.require(:user).permit(:name, :password, :email)
  end
end
