class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  include Response
  include ExceptionHandler

  private

  def admin?
    return true if current_user.role_id == 1
    false
  end

  def get_user_role
     role = Role.find(current_user.try(:role_id))
     role ? role.role : nil
  end

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
