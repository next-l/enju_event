class CreateEventImportFiles < ActiveRecord::Migration[5.1]
  def self.up
    create_table :event_import_files do |t|
      t.integer :parent_id, index: true
      t.references :user, foreign_key: true
      t.text :note
      t.datetime :imported_at
      t.string :edit_mode

      t.timestamps
    end
  end

  def self.down
    drop_table :event_import_files
  end
end
