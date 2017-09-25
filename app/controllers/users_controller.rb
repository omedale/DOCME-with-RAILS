class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login_user register]
  before_action :set_user, only: %i[show update destroy]

  def index
    @user = User.select(:id, :name, :email, :role_id).paginate(page: params[:page], per_page: 20)
    if @user.empty?
      obj = {
        message: 'User not Found'
      }
      return json_response(obj, 404)
    end
    json_response(@user)
  end

  def show
    json_response(@user)
  end

  def update
   puts params[:name]
    if @user.update(user_params)
      obj = {
        message: 'User Updated Succefully'
      }
      return json_response(obj, :ok)
    end
    json_response(@user.errors, :bad)
  end

  def login_user
    authenticate params[:email], params[:password]
  end

  def register
    @user = User.create!(name: params[:name], email: params[:email], password: params[:password], role_id: 2)
    if @user.save
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
    json_response(@user.errors, :created)
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

  def set_user
    @user = User.select(:id, :name, :email, :role_id).find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :password, :email)
  end
end
