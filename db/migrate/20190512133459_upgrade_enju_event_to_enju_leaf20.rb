class UpgradeEnjuEventToEnjuLeaf20 < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up {
        change_table :event_export_file_transitions do |t|
          t.change :event_export_file_id, :bigint
        end

        change_table :event_export_files do |t|
          t.change :user_id, :bigint
        end

        change_table :event_import_file_transitions do |t|
          t.change :event_import_file_id, :bigint
        end

        change_table :event_import_files do |t|
          t.change :user_id, :bigint
          t.change :default_event_category_id, :bigint
          t.change :default_library_id, :bigint
        end

        change_table :event_import_results do |t|
          t.change :event_id, :bigint
          t.change :event_import_file_id, :bigint
        end

        change_table :events do |t|
          t.change :event_category_id, :bigint
          t.change :library_id, :bigint
          t.change :place_id, :bigint
        end

        change_table :participates do |t|
          t.change :agent_id, :bigint
          t.change :event_id, :bigint
        end

        change_table :places do |t|
          t.change :country_id, :bigint
        end

        change_column_null :events, :name, false
      }

      dir.down {
        change_table :event_export_file_transitions do |t|
          t.change :event_export_file_id, :integer
        end

        change_table :event_export_files do |t|
          t.change :user_id, :integer
        end

        change_table :event_import_file_transitions do |t|
          t.change :event_import_file_id, :integer
        end

        change_table :event_import_files do |t|
          t.change :user_id, :integer
          t.change :default_event_category_id, :integer
          t.change :default_library_id, :integer
        end

        change_table :event_import_results do |t|
          t.change :event_id, :integer
          t.change :event_import_file_id, :integer
        end

        change_table :events do |t|
          t.change :event_category_id, :integer
          t.change :library_id, :integer
          t.change :place_id, :integer
        end

        change_table :participates do |t|
          t.change :agent_id, :integer
          t.change :event_id, :integer
        end

        change_table :places do |t|
          t.change :country_id, :integer
        end
      }

      [
        :event_categories,
        :participates,
      ].each do |table|
        change_column_null table, :position, false
        dir.up { change_column table, :position, :integer, default: 1 }
        dir.down { change_column table, :position, :integer, default: nil }
      end
    end

    add_index :event_import_files, :default_event_category_id
    add_index :event_import_files, :default_library_id
    add_index :event_import_results, :event_id
    add_index :event_import_results, :event_import_file_id
    rename_index :event_export_file_translations, :index_event_export_file_transitions_on_file_id, :index_event_export_file_transitions_on_event_export_file_id

    [
      :event_export_files,
      :event_import_files,
    ].each do |table|
      add_foreign_key table, :users
    end

    add_foreign_key :event_import_files, :event_categories, column: :default_event_category_id
    add_foreign_key :event_import_files, :libraries, column: :default_library_id
    add_foreign_key :events, :libraries
    add_foreign_key :events, :places
    add_foreign_key :participates, :events
  end
end
