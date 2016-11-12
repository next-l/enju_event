# == Schema Information
#
# Table name: event_import_results
#
#  id                   :integer          not null, primary key
#  event_import_file_id :integer
#  event_id             :integer
#  body                 :text
#  created_at           :datetime
#  updated_at           :datetime
#

class EventImportResultsController < ApplicationController
  before_action :set_event_import_result, only: [:show, :edit, :update, :destroy]
  before_action :check_policy, only: [:index, :new, :create]

  # GET /event_import_results
  # GET /event_import_results.json
  def index
    @event_import_file = EventImportFile.where(id: params[:event_import_file_id]).first
    @event_import_results = if @event_import_file
                              @event_import_file.event_import_results.page(params[:page])
                            else
                              EventImportResult.page(params[:page])
                            end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event_import_results }
      format.txt
    end
  end

  # GET /event_import_results/1
  # GET /event_import_results/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event_import_result }
    end
  end

  # DELETE /event_import_results/1
  # DELETE /event_import_results/1.json
  def destroy
    @event_import_result.destroy

    respond_to do |format|
      format.html { redirect_to event_import_results_url, notice: t('controller.successfully_deleted', model: t('activerecord.models.event_import_result')) }
      format.json { head :no_content }
    end
  end

  private

  def set_event_import_result
    @event_import_result = EventImportResult.find(params[:id])
    authorize @event_import_result
  end

  def check_policy
    authorize EventImportResult
  end

  def event_import_result_params
    params.require(:event_import_result).permit(
      :event_id, :event_import_file_id, :body # , as: :admin
    )
  end
end
