class AddEditModeToEventImportFile < ActiveRecord::Migration
  def change
    add_column :event_import_files, :edit_mode, :string
  end
end
