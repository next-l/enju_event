class EventImportFileQueue
  @queue = :enju_leaf

  def self.perform(event_import_file_id)
    EventImportFile.find(event_import_file_id).import_start
  end
end
