class AnswerPolicy < ApplicationPolicy
  def update?
    user.present? && (user.admin? || user.id == record.user_id)
  end

  def destroy?
    update?
  end

  def vote?
    user.present? && user.id != record.user_id
  end

  def accept?
    user.present? && user.id == record.question.user_id
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
