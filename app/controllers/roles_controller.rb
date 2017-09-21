class RolesController < ApplicationController
  before_action :set_role, only: [:show, :update, :destroy]

  def index
    @role = Role.all
    json_response(@role)
  end

  def create
    @role = Role.create!(role_params)
    json_response(@role, :created)
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
end
