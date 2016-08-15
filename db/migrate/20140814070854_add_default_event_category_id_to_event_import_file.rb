class AddDefaultEventCategoryIdToEventImportFile < ActiveRecord::Migration
  def change
    add_reference :event_import_files, :default_event_category
  end
end
