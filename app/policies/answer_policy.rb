class AnswerPolicy < ApplicationPolicy
  def update?
    manage?
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
end
