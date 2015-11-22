class EventImportFileJob < ActiveJob::Base
  queue_as :default

  def perform(event_import_file)
    event_import_file.import_start
  end
end
