class CreateColors < ActiveRecord::Migration[5.2]
  def change
    create_table :colors do |t|
      t.references :library_group, foreign_key: true
      t.string :property, null: false
      t.string :code, null: false
      t.integer :position, nill: false, default: 1

      t.timestamps
    end
  end
end
