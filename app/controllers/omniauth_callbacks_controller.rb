class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :redirect_if_signed_in

  def facebook
    general_auth
  end

  def twitter
    general_auth
  end

  private

  def general_auth
    auth = request.env['omniauth.auth']

    identity = Identity.find_for_oauth(auth)
    return sign_in_with_oauth(identity.user, auth.provider) if identity.present?

    user = User.find_for_oauth(auth)
    return sign_in_with_oauth(user, auth.provider) if user.present?

    session["devise.oauth_data"] = {provider: auth.provider, uid: auth.uid}
    redirect_to finish_signup_path
  end

  def redirect_if_signed_in
    redirect_to root_path if signed_in?
  end
end
