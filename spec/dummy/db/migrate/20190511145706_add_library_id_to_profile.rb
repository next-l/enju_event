class AddLibraryIdToProfile < ActiveRecord::Migration[5.2]
  def change
    add_reference :profiles, :library, foreign_key: true, null: false
  end
end
