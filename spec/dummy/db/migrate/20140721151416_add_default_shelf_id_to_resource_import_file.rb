class AddDefaultShelfIdToResourceImportFile < ActiveRecord::Migration[5.2]
  def change
    add_reference :resource_import_files, :default_shelf, foreign_key: {to_table: :shelves}
  end
end
