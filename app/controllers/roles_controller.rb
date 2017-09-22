class RolesController < ApplicationController
  before_action :authorize
  before_action :set_role, only: [:show, :update, :destroy]

  def index
    @role = Role.select(:id, :role).all
    json_response(@role)
  end

  def create
   @role = Role.create!(role_params)
    if(@role.save)
      return json_response(@role, :created)
    end
    return json_response(@role.errors, :created)
  end

  def show
    json_response(@role)
  end

  def update
    @role.update(role_params)
    head :no_content
  end

  def destroy
    @role.destroy
    head :no_content
  end

  private

  def role_params
    params.permit(:role, :description)
  end

  def set_role
    @role = Role.find(params[:id])
  end

  def authorize
    unless  is_admin
      status = 401
      obj = {message: 'Unauthorized'}
      json_response(obj, status)
    end
  end
end
