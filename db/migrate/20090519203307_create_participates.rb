class CreateParticipates < ActiveRecord::Migration[5.2]
  def change
    create_table :participates do |t|
      t.references :agent, index: true, null: false
      t.references :event, foreign_key: true, null: false
      t.integer :position, default: 1, null: false

      t.timestamps
    end
  end
end
