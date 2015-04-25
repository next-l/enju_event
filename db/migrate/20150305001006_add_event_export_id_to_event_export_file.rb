class AddEventExportIdToEventExportFile < ActiveRecord::Migration
  def change
    add_column :event_export_files, :event_export_id, :string
    add_column :event_export_files, :event_export_size, :integer
    rename_column :event_export_files, :event_export_file_name, :event_export_filename
    add_index :event_export_files, :event_export_id
  end
end
