class EventImportFileQueue
  def self.perform(event_import_file_id)
    EventImportFile.find(event_import_file_id).import_start
  end
end
