class CreateIdentifiers < ActiveRecord::Migration[5.2]
  def change
    create_table :identifiers do |t|
      t.string :body, null: false
      t.references :identifier_type, foreign_key: true, null: false, index: false
      t.references :manifestation, foreign_key: true, null: false
      t.boolean :primary
      t.integer :position

      t.timestamps
    end
    add_index :identifiers, [:body, :identifier_type_id]
  end
end
