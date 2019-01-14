class CreateEventImportFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :event_import_files do |t|
      t.string :content_type
      t.integer :size
      t.references :user, index: true
      t.text :note
      t.datetime :imported_at
      t.string :event_import_file_name
      t.string :event_import_content_type
      t.integer :event_import_file_size
      t.datetime :event_import_updated_at
      t.string :edit_mode

      t.timestamps
    end
  end
end
