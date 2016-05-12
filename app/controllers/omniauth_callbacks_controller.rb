class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :redirect_if_signed_in

  def facebook
    general_auth
  end

  def twitter
    general_auth
  end

  # class_eval ???

  private

  def general_auth
    auth = request.env['omniauth.auth']

    identity = Identity.find_for_oauth(auth)
    return sign_in_with_oauth(identity.user) if identity.present?

    user = User.find_for_oauth(auth)
    sign_in_with_oauth(user) if user.persisted?
  end

  def sign_in_with_oauth(user)
    sign_in_and_redirect user, event: :authentication
    set_flash_message :notice, :success, kind: 'Facebook' if is_navigational_format?
  end

  def redirect_if_signed_in
    redirect_to root_path if signed_in?
  end

  protected

  def after_sign_in_path_for(resource)
    if current_user.email_verified?
      super
    else
      finish_signup_path
    end
  end
end
