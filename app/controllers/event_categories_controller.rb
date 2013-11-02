class EventCategoriesController < InheritedResources::Base
  respond_to :html, :json
  load_and_authorize_resource :except => :index
  authorize_resource :only => :index

  def update
    @event_category = EventCategory.find(params[:id])
    if params[:move]
      move_position(@event_category, params[:move])
      return
    end
    update!
  end

  def index
    @event_categories = EventCategory.page(params[:page])
  end
end
