class QuestionPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def update?
    user.try(:admin?) || user == record.user
  end

  def destroy?
    update?
  end

  def vote?
    user.present? && user != record.user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
