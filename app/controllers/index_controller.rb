class IndexController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login_user register verifyaccess]

  def login_user
    authenticate params[:email], params[:password]
  end

  def register
    @user = User.create!(name: params[:name], email: params[:email], password: params[:password], role_id: 2)
    if @user.save
      command = AuthenticateUser.call(params[:email], params[:password])
      if command.success?
        data = {
          auth_token: command.result,
          name: @user.name,
          email: @user.email,
          role_id: @user.role_id,
          message: 'User Created Succefully and Logged in'
        }
        return json_response(data, :created)
      else
        render json: { error: command.errors }, status: :unauthorized
      end
    end
    json_response(@user.errors, :created)
  end

  def verifyaccess
    verifyaccess_with_token params[:token]
  end

  private

  def verifyaccess_with_token(token)
    JsonWebToken.decode(token)
  end

  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)

    if command.success?
      render json: {
        auth_token: command.result,
        message: 'Login Successful'
      }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
end
