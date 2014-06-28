class EventImportFilesController < ApplicationController
  before_action :set_event_import_file, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /event_import_files
  def index
    authorize EventImportFile
    @event_import_files = EventImportFile.page(params[:page])
  end

  # GET /event_import_files/1
  # GET /event_import_files/1.json
  def show
    if @event_import_file.event_import.path
      unless Setting.uploaded_file.storage == :s3
        file = @event_import_file.event_import.path
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event_import_file }
      format.download {
        if Setting.uploaded_file.storage == :s3
          redirect_to @event_import_file.event_import.expiring_url(10)
        else
          send_file file, :filename => @event_import_file.event_import_file_name, :type => 'application/octet-stream'
        end
      }
    end
  end

  # GET /event_import_files/new
  def new
    @event_import_file = EventImportFile.new
    authorize @event_import_file
  end

  # GET /event_import_files/1/edit
  def edit
  end

  # POST /event_import_files
  # POST /event_import_files.json
  def create
    authorize EventImportFile
    @event_import_file = EventImportFile.new(event_import_file_params)
    @event_import_file.user = current_user

    respond_to do |format|
      if @event_import_file.save
        flash[:notice] = t('controller.successfully_created', :model => t('activerecord.models.event_import_file'))
        format.html { redirect_to(@event_import_file) }
        format.json { render :json => @event_import_file, :status => :created, :location => @event_import_file }
      else
        format.html { render :action => "new" }
        format.json { render :json => @event_import_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /event_import_files/1
  # PUT /event_import_files/1.json
  def update
    respond_to do |format|
      if @event_import_file.update_attributes(event_import_file_params)
        flash[:notice] = t('controller.successfully_updated', :model => t('activerecord.models.event_import_file'))
        format.html { redirect_to(@event_import_file) }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @event_import_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /event_import_files/1
  # DELETE /event_import_files/1.json
  def destroy
    @event_import_file.destroy

    respond_to do |format|
      format.html { redirect_to event_import_files_url }
      format.json { head :no_content }
    end
  end

  private
  def set_event_import_file
    @event_import_file = EventImportFile.find(params[:id])
    authorize @event_import_file
  end

  def event_import_file_params
    params.require(:event_import_file).permit(
      :event_import, :edit_mode, :user_encoding
    )
  end
end
