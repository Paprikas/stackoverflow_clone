class RegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_confirmed

  def finish_signup
  end

  def send_confirmation_email
    # ??? valid data?
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

  def redirect_if_confirmed
    redirect_to root_path, notice: 'Registration successfully finished' if current_user.confirmed?
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
