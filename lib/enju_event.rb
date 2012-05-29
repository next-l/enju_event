require "enju_event/engine"
require 'event_calendar'

module EnjuEvent
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def enju_event
      include EnjuEvent::InstanceMethods
    end
  end

  module InstanceMethods
    def get_event
      @event = Event.find(params[:event_id]) if params[:event_id]
    end
  end
end

ActionController::Base.send(:include, EnjuEvent)
