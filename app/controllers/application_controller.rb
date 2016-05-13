require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_gon_user

  private

  def set_gon_user
    gon.user_id = current_user.try(:id)
  end

  def sign_in_with_oauth(user, provider)
    sign_in_and_redirect user, event: :authentication
    flash[:notice] = t('devise.omniauth_callbacks.success', kind: provider.to_s.camelize) if is_navigational_format?
  end
end
