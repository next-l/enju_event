class EventImportResultPolicy < ApplicationPolicy
  def create?
    user.try(:has_role?, 'Administrator')
  end

  def destroy?
    user.try(:has_role?, 'Administrator')
  end
end
