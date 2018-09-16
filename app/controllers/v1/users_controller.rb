module V1
  class UsersController < ApplicationController
    before_action :set_user, only: %i[show destroy]
    before_action :admin_user, only: %i[index search]

    def index
      @user = User.select(:id, :name, :email, :role_id).paginate(page: params[:page], per_page: 20)

      return custom_response('user', 404) if @user.empty? 
      return json_response(@user)
    end

    def show
      return custom_response('user', 401) if params[:id].to_i != current_user.id.to_i && !admin?
      return json_response(@user)
    end

    def search
      if params[:q]
        @user = User.search(params[:q]).select(:id, :name, :email, :role_id).paginate(page: params[:page], per_page: 20)
        return custom_response('user', 404) if @user.empty?
        return json_response(@user, :ok)
      else
        return custom_response('user', 400)
      end
    end

    def update
      return custom_response('user', 401)  if params[:id].to_i != current_user.id.to_i && !admin?
  
      if params[:email]
        @user = User.where(email: params[:email])
        unless @user.empty?
          return json_response({ message: 'Email Already Exist' }, :bad)
        end
      end 

      @user = User.find(params[:id])
      @user.attributes = user_params
  
      return json_response({ message: 'User Updated Succefully' }, :ok) if @user.save(validate: false)
      json_response(@user.errors, :bad)
    end
  

    def destroy
      return custom_response('user', 401) if params[:id].to_i != current_user.id.to_i && !admin?
      return json_response({ message: 'User Deleted Succefully' }, :ok) if @user.destroy

      return json_response(@user.errors, :bad)
    end

    private

    def admin_user
      unless admin?
        custom_response('user', 401)
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