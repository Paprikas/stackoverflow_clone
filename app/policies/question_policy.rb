class QuestionPolicy < ApplicationPolicy
  def update?
    user.present? && (user.admin? || user.id == record.user_id)
  end

  def destroy?
    update?
  end

  def vote?
    user.present? && user.id != record.user_id
  end
end
