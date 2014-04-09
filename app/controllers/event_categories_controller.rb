class EventCategoriesController < ApplicationController
  before_action :set_event_category, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  #after_action :verify_policy_scoped, :only => :index

  # GET /event_categories
  def index
    authorize EventCategory
    @event_categories = EventCategory.order(:position).page(1)
  end

  # GET /event_categories/1
  def show
  end

  # GET /event_categories/new
  def new
    @event_category = EventCategory.new
    authorize @event_category
  end

  # GET /event_categories/1/edit
  def edit
  end

  # POST /event_categories
  def create
    @event_category = EventCategory.new(event_category_params)
    authorize @event_category

    if @event_category.save
      redirect_to @event_category, notice:  t('controller.successfully_created', :model => t('activerecord.models.event_category'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /event_categories/1
  def update
    if params[:move]
      move_position(@event_category, params[:move])
      return
    end
    if @event_category.update(event_category_params)
      redirect_to @event_category, notice:  t('controller.successfully_updated', :model => t('activerecord.models.event_category'))
    else
      render action: 'edit'
    end
  end

  # DELETE /event_categories/1
  def destroy
    @event_category.destroy
    redirect_to event_categories_url, notice: 'Event category was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_category
      @event_category = EventCategory.find(params[:id])
      authorize @event_category
    end

    # Only allow a trusted parameter "white list" through.
    def event_category_params
      params.require(:event_category).permit(:name, :display_name, :note)
    end
end
