class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_gon_user

  private

  def set_gon_user
    gon.user_id = current_user.try(:id)
  end
end
