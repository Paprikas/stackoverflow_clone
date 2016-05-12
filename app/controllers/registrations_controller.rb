class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def finish_signup
  end

  def send_confirmation_email
    user = User.find_by(user_params)

    if user && current_user != user
      flash[:notice] = 'User with provided email already registered'
    elsif current_user.update(user_params)
      flash[:notice] = 'Confirmation email successfully sent'
    else
      flash[:alert] = 'Error'
    end

    redirect_to finish_signup_path
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
