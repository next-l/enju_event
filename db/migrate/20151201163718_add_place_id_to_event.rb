class AddPlaceIdToEvent < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :place, foreign_key: true
  end
end
