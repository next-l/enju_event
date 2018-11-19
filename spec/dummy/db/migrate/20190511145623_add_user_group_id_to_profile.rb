class AddUserGroupIdToProfile < ActiveRecord::Migration[5.2]
  def change
    add_reference :profiles, :user_group, foreign_key: true, null: false
  end
end
