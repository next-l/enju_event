class AddDefaultLibraryIdToEventImportFile < ActiveRecord::Migration
  def change
    add_reference :event_import_files, :default_library
  end
end
