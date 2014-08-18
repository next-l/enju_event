class EventCategoriesController < ApplicationController
  load_and_authorize_resource
  # GET /event_categories
  # GET /event_categories.json
  def index
    @event_categories = EventCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event_categories }
    end
  end

  # GET /event_categories/1
  # GET /event_categories/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event_category }
    end
  end

  # GET /event_categories/new
  # GET /event_categories/new.json
  def new
    @event_category = EventCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event_category }
    end
  end

  # GET /event_categories/1/edit
  def edit
  end

  # POST /event_categories
  # POST /event_categories.json
  def create
    @event_category = EventCategory.new(params[:event_category])

    respond_to do |format|
      if @event_category.save
        format.html { redirect_to @event_category, notice:  t('controller.successfully_created', model:  t('activerecord.models.event_category')) }
        format.json { render json: @event_category, status: :created, location: @event_category }
      else
        format.html { render action: "new" }
        format.json { render json: @event_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /event_categories/1
  # PUT /event_categories/1.json
  def update
    if params[:move]
      move_position(@event_category, params[:move])
      return
    end

    respond_to do |format|
      if @event_category.update_attributes(params[:event_category])
        format.html { redirect_to @event_category, notice:  t('controller.successfully_updated', model:  t('activerecord.models.event_category')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_categories/1
  # DELETE /event_categories/1.json
  def destroy
    @event_category.destroy

    respond_to do |format|
      format.html { redirect_to event_categories_url, notice: t('controller.successfully_deleted', model: t('activerecord.models.event_category')) }
      format.json { head :no_content }
    end
  end
end
