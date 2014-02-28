class EventCategoriesController < InheritedResources::Base
  respond_to :html, :json
  load_and_authorize_resource except: [:index, :create]
  authorize_resource only: [:index, :create]

  def index
    @event_categories = EventCategory.page(params[:page])
  end

  def update
    @event_category = EventCategory.find(params[:id])
    if params[:move]
      move_position(@event_category, params[:move])
      return
    end
    update!
  end

  private
  def permitted_params
    params.permit(
      :event_category => [:name, :display_name, :note]
    )
  end
end
