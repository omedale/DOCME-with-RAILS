module V1
  class UsersController < ApplicationController
    before_action :set_user, only: %i[show destroy]
    before_action :admin_user, only: %i[index search]

    def index
      @user = User.select(:id, :name, :email, :role_id).paginate(page: params[:page], per_page: 20)
      if @user.empty?
        data = {
          message: 'User not Found'
        }
        return json_response(data, 404)
      end
      json_response(@user)
    end

    def show
      if params[:id].to_i != current_user.id.to_i && current_user.role_id != 1
        data = {
          message: 'Unauthorized Access'
        }
        return json_response(data, 401)
      end
      json_response(@user)
    end

    def search
      if params[:q]
        @user = User.search(params[:q]).select(:id, :name, :email, :role_id).paginate(page: params[:page], per_page: 20)
        if @user.empty?
          data = {
            message: 'User not Found'
          }
          return json_response(data, 404)
        end
        return json_response(@user, :ok)
      else
        data = {
          message: 'No search key, Use routes \'/users/search/{search value}\''
        }
        return json_response(data, :bad)
      end
    end

    def update
      if params[:id].to_i != current_user.id.to_i && current_user.role_id != 1
        data = {
          message: 'Unauthorized Access'
        }
        return json_response(data, 401)
      end
      if params[:email]
        @user = User.where(email: params[:email])
        unless @user.empty?
          data = {
            message: 'Email Already Exist'
          }
          return json_response(data, :bad)
        end
      end 

    @user = User.find(params[:id])
    @user.attributes = user_params
  
      if @user.save(validate: false)
        data = {
          message: 'User Updated Succefully'
        }
        return json_response(data, :ok)
      end
      json_response(@user.errors, :bad)
    end
  

    def destroy
      if params[:id].to_i != current_user.id.to_i && current_user.role_id != 1
        data = {
          message: 'Unauthorized Access'
        }
        return json_response(data, 401)
      end
      if @user.destroy
        data = {
          message: 'User Deleted Succefully'
        }
        return json_response(data, :ok)
      end
      json_response(@user.errors, :bad)
    end

    private

    def admin_user
      unless admin?
        data = {
          message: 'Unauthorized Access'
        }
        return json_response(data, 401)
      end
    end

    def set_user
      @user = User.select(:id, :name, :email, :role_id).find(params[:id])
    end

    def user_params
      params.permit(:name, :password, :email)
    end
  end
end