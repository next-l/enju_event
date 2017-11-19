class CreateParticipates < ActiveRecord::Migration[5.1]
  def change
    create_table :participates do |t|
      t.references :agent, null: false, index: true
      t.references :event, null: false, foreign_key: true, type: :uuid
      t.integer :position

      t.timestamps
    end
  end
end
