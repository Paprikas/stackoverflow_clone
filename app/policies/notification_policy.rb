class NotificationPolicy < ApplicationPolicy
  def destroy?
    manage?
  end
end
