class RolesController < ApplicationController
  before_action :authorize
  before_action :set_role, only: %i[show update destroy]

  def index
    @role = Role.select(:id, :role).all
    if @role.empty?
      data = {
        message: 'Role not Found'
      }
      return json_response(data, 404)
      end
    json_response(@role)
  end

  def create
    @role = Role.create!(role_params)
    return json_response(@role, :created) if @role.save
    json_response(@role.errors, :bad)
  end

  def show
    json_response(@role)
  end

  def update
    @role.attributes = role_params
    if @role.save(validate: false)
      data = {
        message: 'Role Updated Succefully'
      }
      return json_response(data, :ok)
    end
    json_response(@role.errors, :bad)
  end

  def destroy
    if @role.destroy
      data = {
        message: 'Role Deleted Succefully'
      }
      return json_response(data, :ok)
    end
    json_response(@role.errors, :bad)
  end

  private

  def role_params
    params.permit(:role, :description)
  end

  def set_role
    @role = Role.select(:id, :role).find(params[:id])
  end

  def authorize
    unless  admin?
      status = 401
      data = { message: 'Unauthorized' }
      json_response(data, status)
    end
  end
end
