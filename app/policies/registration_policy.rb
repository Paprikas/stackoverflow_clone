class RegistrationPolicy < ApplicationPolicy
  def finish_signup?
    user.nil?
  end

  def send_confirmation_email?
    finish_signup?
  end
end
