class EventImportFilesController < ApplicationController
  before_action :set_event_import_file, only: [:show, :edit, :update, :destroy]
  before_action :prepare_options, only: [:new, :edit]
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
  # GET /event_import_files/new.json
  def new
    @event_import_file = EventImportFile.new
    authorize @event_import_file
    @event_import_file.default_library = current_user.library
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

    if @event_import_file.save
      if @event_import_file.mode == 'import'
        Resque.enqueue(EventImportFileQueue, @event_import_file.id)
      end
      redirect_to @event_import_file, notice: t('import.successfully_created', model: t('activerecord.models.event_import_file'))
    else
      prepare_options
      render action: 'new'
    end
  end

  # PUT /event_import_files/1
  # PUT /event_import_files/1.json
  def update
    if @event_import_file.update(event_import_file_params)
      if @event_import_file.mode == 'import'
        Resque.enqueue(EventImportFileQueue, @event_import_file.id)
      end
      redirect_to @event_import_file, notice: t('controller.successfully_updated', :model => t('activerecord.models.event_import_file'))
    else
      prepare_options
      render :edit
    end
  end

  # DELETE /event_import_files/1
  # DELETE /event_import_files/1.json
  def destroy
    @event_import_file.destroy
    redirect_to event_import_files_url, notice: t('controller.successfully_destroyed', :model => t('activerecord.models.event_import_file'))
  end

  private
  def set_event_import_file
    @event_import_file = EventImportFile.find(params[:id])
    authorize @event_import_file
  end

  def event_import_file_params
    params.require(:event_import_file).permit(
      :event_import, :edit_mode, :user_encoding, :mode, :default_library_id
    )
  end

  def prepare_options
    @libraries = Library.all
  end
end
