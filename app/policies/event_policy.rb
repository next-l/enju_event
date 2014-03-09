class EventPolicy < AdminPolicy
  def index?
    true
  end

  def create?
    user.try(:has_role?, 'Librarian')
  end

  def destroy?
    user.try(:has_role?, 'Librarian')
  end
end
