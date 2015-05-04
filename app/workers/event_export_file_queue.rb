class EventExportFileQueue
  @queue = :enju_leaf

  def self.perform(event_export_id)
    EventExportFile.find(event_export_id).export!
  end
end
