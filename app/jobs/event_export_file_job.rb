class EventExportFileJob < ActiveJob::Base
  queue_as :default

  def perform(event_export_file)
    event_export_file.export!
  end
end
