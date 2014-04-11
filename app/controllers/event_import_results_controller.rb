class EventImportResultsController < ApplicationController
  before_action :set_event_import_result, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  def index
    authorize EventImportResult
    @event_import_file = EventImportFile.where(:id => params[:event_import_file_id]).first
    if @event_import_file
      @event_import_results = @event_import_file.event_import_results.page(params[:page])
    else
      @event_import_results = EventImportResult.page(params[:page])
    end
  end

  def show
  end

  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_import_result
      @event_import_result = EventImportResult.find(params[:id])
      authorize @event_import_result
    end
end
