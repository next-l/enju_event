class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.references :library, foreign_key: true, null: false, type: :uuid
      t.references :event_category, null: false, index: true
      t.string :name
      t.text :note
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :all_day, default: false, null: false
      t.jsonb :display_name_translations

      t.timestamps
    end
  end
end
