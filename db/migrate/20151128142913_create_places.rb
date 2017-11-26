class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|
      t.string :term, index: true, null: false
      t.text :city
      t.references :country, foreign_key: true
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
