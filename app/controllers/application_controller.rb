class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user
  
  include Response
  include ExceptionHandler

  private

  def is_admin
    if current_user.role_id == 1
      return true
    end
    return false
  end

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
