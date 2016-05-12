require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_gon_user
  before_action :ensure_signup_finished, except: [:index, :show]

  private

  def set_gon_user
    gon.user_id = current_user.try(:id)
  end

  def ensure_signup_finished
    return if %w(sessions).include?(controller_name) || %w(finish_signup send_confirmation_email).include?(action_name)
    redirect_to finish_signup_path if current_user && (!current_user.email_verified? || !current_user.confirmed?)
  end
end
