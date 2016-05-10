class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # test???
  def facebook
    @user = User.find_with_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message :notice, :success, kind: 'Facebook' if is_navigational_format?
    end
  end
end
