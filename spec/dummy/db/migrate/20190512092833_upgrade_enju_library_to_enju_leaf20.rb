class UpgradeEnjuLibraryToEnjuLeaf20 < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up {
        change_table :accepts do |t|
          t.change :basket_id, :bigint
          t.change :item_id, :bigint
          t.change :librarian_id, :bigint
        end

        change_table :baskets do |t|
          t.change :user_id, :bigint
        end

        change_table :colors do |t|
          t.change :library_group_id, :bigint
        end

        change_table :libraries do |t|
          t.change :library_group_id, :bigint
          t.change :country_id, :bigint
        end

        change_table :library_groups do |t|
          t.change :user_id, :bigint
        end

        change_table :profiles do |t|
          t.change :library_id, :bigint
          t.change :user_group_id, :bigint
        end

        change_table :subscribes do |t|
          t.change :subscription_id, :bigint
          t.change :work_id, :bigint
        end

        change_table :subscriptions do |t|
          t.change :order_list_id, :bigint
          t.change :user_id, :bigint
        end

        change_table :user_import_file_transitions do |t|
          t.change :user_import_file_id, :bigint
        end

        change_table :user_import_files do |t|
          t.change :user_id, :bigint
          t.change :default_library_id, :bigint
          t.change :default_user_group_id, :bigint
        end

        change_table :user_export_file_transitions do |t|
          t.change :user_export_file_id, :bigint
        end

        change_table :user_export_files do |t|
          t.change :user_id, :bigint
        end

        change_table :user_import_results do |t|
          t.change :user_id, :bigint
          t.change :user_import_file_id, :bigint
        end

        change_table :withdraws do |t|
          t.change :basket_id, :bigint
          t.change :item_id, :bigint
          t.change :librarian_id, :bigint
        end

        change_column_null :budget_types, :display_name, false
        change_column_null :colors, :property, false
        change_column_null :colors, :code, false
        [
          :budget_types,
          :user_groups
        ].each do |table|
          change_column_null table, :name, false
        end

        add_index :libraries, :country_id
        remove_index :libraries, :name
        add_index :libraries, :name, unique: true
        remove_index :user_export_file_transitions, name: 'index_user_export_file_transitions_on_file_id'

        add_foreign_key :accepts, :baskets
        add_foreign_key :accepts, :users, column: :librarian_id
        add_foreign_key :colors, :library_groups
        add_foreign_key :shelves, :libraries
        add_foreign_key :subscribes, :subscriptions
        add_foreign_key :user_import_results, :user_import_files
        add_foreign_key :withdraws, :baskets
        add_foreign_key :withdraws, :users, column: :librarian_id
      }

      dir.down {
        change_table :accepts do |t|
          t.change :basket_id, :integer
          t.change :item_id, :integer
          t.change :librarian_id, :integer
        end

        change_table :baskets do |t|
          t.change :user_id, :integer
        end

        change_table :colors do |t|
          t.change :library_group_id, :integer
        end

        change_table :libraries do |t|
          t.change :library_group_id, :integer
          t.change :country_id, :integer
        end

        change_table :library_groups do |t|
          t.change :user_id, :integer
        end

        change_table :profiles do |t|
          t.change :library_id, :integer
          t.change :user_group_id, :integer
        end

        change_table :subscribes do |t|
          t.change :subscription_id, :integer
          t.change :work_id, :integer
        end

        change_table :subscriptions do |t|
          t.change :order_list_id, :integer
          t.change :user_id, :integer
        end

        change_table :user_import_file_transitions do |t|
          t.change :user_import_file_id, :integer
        end

        change_table :user_import_files do |t|
          t.change :user_id, :integer
          t.change :default_library_id, :integer
          t.change :default_user_group_id, :integer
        end

        change_table :user_export_file_transitions do |t|
          t.change :user_export_file_id, :integer
        end

        change_table :user_export_files do |t|
          t.change :user_id, :integer
        end

        change_table :user_import_results do |t|
          t.change :user_id, :integer
          t.change :user_import_file_id, :integer
        end

        change_table :withdraws do |t|
          t.change :basket_id, :integer
          t.change :item_id, :integer
          t.change :librarian_id, :integer
        end

        remove_index :libraries, :country_id
        remove_index :libraries, :name
        add_index :libraries, :name
        add_index :user_export_file_transitions, :user_export_file_id, name: 'index_user_export_file_transitions_on_file_id'

        remove_foreign_key :accepts, :baskets
        remove_foreign_key :accepts, :users
        remove_foreign_key :colors, :library_groups
        remove_foreign_key :shelves, :libraries
        remove_foreign_key :subscribes, :subscriptions
        remove_foreign_key :user_import_results, :user_import_files
        remove_foreign_key :withdraws, :baskets
        remove_foreign_key :withdraws, :users
      }

      [
        :budget_types,
        :library_groups,
        :user_groups
      ].each do |table|
        dir.up { add_index table.to_sym, :name, unique: true }
        dir.down { remove_index table.to_sym, :name }
      end

      [
        :bookstores,
        :budget_types,
        :colors,
        :libraries,
        :library_groups,
        :request_status_types,
        :request_types,
        :search_engines,
        :shelves,
        :user_groups
      ].each do |table|
        change_column_null table, :position, false
        dir.up { change_column table, :position, :integer, default: 1 }
        dir.down { change_column table, :position, :integer, default: nil }
      end

      [
        :baskets,
        :subscriptions,
        :user_export_files,
        :user_import_files,
        :user_import_results
      ].each do |table|
        dir.up {
          add_foreign_key table, :users
        }
        dir.down {
          remove_foreign_key table, :users
        }
      end
    end

    add_foreign_key :profiles, :libraries
    add_foreign_key :profiles, :user_groups
    change_column_null :profiles, :user_group_id, false
  end
end
