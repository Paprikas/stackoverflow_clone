class OmniauthCallbacksControllerPolicy < ApplicationPolicy
  def facebook?
    user.nil?
  end

  def twitter?
    facebook?
  end
end
