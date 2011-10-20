class EventCategoriesController < InheritedResources::Base
  respond_to :html, :xml
  load_and_authorize_resource

  def update
    @event_category = EventCategory.find(params[:id])
    if params[:position]
      @event_category.insert_at(params[:position])
      redirect_to event_categories_url
      return
    end
    update!
  end

  def index
    @event_categories = @event_categories.page(params[:page])
  end
end
