class AddDefaultEventCategoryIdToEventImportFile < ActiveRecord::Migration[5.2]
  def change
    add_reference :event_import_files, :default_event_category, foreign_key: {to_table: :event_categories}
  end
end
