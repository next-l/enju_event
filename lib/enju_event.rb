require "enju_event/engine"

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
      authorize @event, :show if @event
    end
  end
end

ActionController::Base.send(:include, EnjuEvent)
