module EnjuEvent
  class Ability
    include CanCan::Ability
  
    def initialize(user, ip_address = nil)
      case user.try(:role).try(:name)
      when 'Administrator'
        can [:destroy, :delete], EventCategory do |event_category|
          !['unknown', 'closed'].include?(event_category.name)
        end
        can :manage, [
          EventImportFile,
          EventExportFile,
          Participate
        ]
        can :read, EventImportResult
      when 'Librarian'
        can :manage, [
          EventImportFile,
          EventExportFile,
          Participate
        ]
        can :read, [
          EventImportResult
        ]
      end
    end
  end
end
