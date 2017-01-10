module EnjuEvent
  module Controller
    private

    def set_parent_event
      if params[:event_id]
        @event = Event.find(params[:event_id])
        authorize @event, :show?
      end
    end
  end
end
