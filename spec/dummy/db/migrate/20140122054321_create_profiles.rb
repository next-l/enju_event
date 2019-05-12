class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :locale
      t.string :user_number, index: {unique: true}
      t.text :full_name
      t.text :note
      t.text :keyword_list
      t.references :required_role, index: false, null: false

      t.timestamps
    end
  end
end
