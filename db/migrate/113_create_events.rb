class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.references :library, null: false, index: true
      t.references :event_category, null: false, index: true
      t.string :name
      t.text :note
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :all_day, default: false, null: false
      t.datetime :deleted_at
      t.text :display_name

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
