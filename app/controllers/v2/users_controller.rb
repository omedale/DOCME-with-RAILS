
class V2::UsersController < ApplicationController
  before_action :set_user, only: %i[show destroy]
  before_action :admin_user, only: %i[index search]

  def index
    data = {
        message: 'Veersion 2'
    }
    json_response(data)
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
end