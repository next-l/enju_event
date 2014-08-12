class EventExportFileQueue
  @queue = :event_export_file

  def self.perform(event_export_id)
    EventExportFile.find(event_export_id).export!
  end
end
