class Api::V1::ApplicationController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  def me
    authorize :profiles
    respond_with current_resource_owner
  end

  def all
    authorize :profiles
    respond_with User.where.not(id: current_resource_owner)
  end

  protected

  def current_user
    current_resource_owner
  end

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
