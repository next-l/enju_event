class EventCategoryPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.try(:has_role?, 'Administrator')
  end

  def update?
    user.try(:has_role?, 'Administrator')
  end

  def destroy?
    return false unless user.try(:has_role?, 'Administrator')
    true unless %w(unknown closed).include?(record.name)
  end
end
