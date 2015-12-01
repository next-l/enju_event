class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :term
      t.text :city
      t.integer :country_id
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
    add_index :places, :term
    add_index :places, :country_id
  end
end
