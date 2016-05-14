class AnswerPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def update?
    user&.admin? || user == record.user
  end

  def destroy?
    update?
  end

  def vote?
    user.present? && user != record.user
  end

  def accept?
    user.present? && user == record.question.user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
