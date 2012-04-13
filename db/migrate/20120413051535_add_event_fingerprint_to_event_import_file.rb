class AddEventFingerprintToEventImportFile < ActiveRecord::Migration
  def change
    add_column :event_import_files, :event_fingerprint, :string
  end
end
