# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111201163718) do

  create_table "countries", :force => true do |t|
    t.string  "name",         :null => false
    t.text    "display_name"
    t.string  "alpha_2"
    t.string  "alpha_3"
    t.string  "numeric_3"
    t.text    "note"
    t.integer "position"
  end

  add_index "countries", ["alpha_2"], :name => "index_countries_on_alpha_2"
  add_index "countries", ["alpha_3"], :name => "index_countries_on_alpha_3"
  add_index "countries", ["name"], :name => "index_countries_on_name"
  add_index "countries", ["numeric_3"], :name => "index_countries_on_numeric_3"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "event_categories", :force => true do |t|
    t.string   "name",         :null => false
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_import_files", :force => true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.integer  "size"
    t.string   "file_hash"
    t.integer  "user_id"
    t.text     "note"
    t.datetime "imported_at"
    t.string   "state"
    t.string   "event_import_file_name"
    t.string   "event_import_content_type"
    t.integer  "event_import_file_size"
    t.datetime "event_import_updated_at"
    t.string   "edit_mode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_import_files", ["file_hash"], :name => "index_event_import_files_on_file_hash"
  add_index "event_import_files", ["parent_id"], :name => "index_event_import_files_on_parent_id"
  add_index "event_import_files", ["state"], :name => "index_event_import_files_on_state"
  add_index "event_import_files", ["user_id"], :name => "index_event_import_files_on_user_id"

  create_table "event_import_results", :force => true do |t|
    t.integer  "event_import_file_id"
    t.integer  "event_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "library_id",        :default => 1,     :null => false
    t.integer  "event_category_id", :default => 1,     :null => false
    t.string   "name"
    t.text     "note"
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean  "all_day",           :default => false, :null => false
    t.datetime "deleted_at"
    t.text     "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["event_category_id"], :name => "index_events_on_event_category_id"
  add_index "events", ["library_id"], :name => "index_events_on_library_id"

  create_table "languages", :force => true do |t|
    t.string  "name",         :null => false
    t.string  "native_name"
    t.text    "display_name"
    t.string  "iso_639_1"
    t.string  "iso_639_2"
    t.string  "iso_639_3"
    t.text    "note"
    t.integer "position"
  end

  add_index "languages", ["iso_639_1"], :name => "index_languages_on_iso_639_1"
  add_index "languages", ["iso_639_2"], :name => "index_languages_on_iso_639_2"
  add_index "languages", ["iso_639_3"], :name => "index_languages_on_iso_639_3"
  add_index "languages", ["name"], :name => "index_languages_on_name", :unique => true

  create_table "libraries", :force => true do |t|
    t.integer  "patron_id"
    t.string   "patron_type"
    t.string   "name",                                   :null => false
    t.text     "display_name"
    t.string   "short_display_name",                     :null => false
    t.string   "zip_code"
    t.text     "street"
    t.text     "locality"
    t.text     "region"
    t.string   "telephone_number_1"
    t.string   "telephone_number_2"
    t.string   "fax_number"
    t.text     "note"
    t.integer  "call_number_rows",      :default => 1,   :null => false
    t.string   "call_number_delimiter", :default => "|", :null => false
    t.integer  "library_group_id",      :default => 1,   :null => false
    t.integer  "users_count",           :default => 0,   :null => false
    t.integer  "position"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "libraries", ["library_group_id"], :name => "index_libraries_on_library_group_id"
  add_index "libraries", ["name"], :name => "index_libraries_on_name", :unique => true
  add_index "libraries", ["patron_id"], :name => "index_libraries_on_patron_id", :unique => true

  create_table "library_groups", :force => true do |t|
    t.string   "name",                                                              :null => false
    t.text     "display_name"
    t.string   "short_name",                                                        :null => false
    t.string   "email"
    t.text     "my_networks"
    t.text     "login_banner"
    t.text     "note"
    t.integer  "valid_period_for_new_user",   :default => 365,                      :null => false
    t.boolean  "post_to_union_catalog",       :default => false,                    :null => false
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "admin_networks"
    t.boolean  "allow_bookmark_external_url", :default => false,                    :null => false
    t.integer  "position"
    t.string   "url",                         :default => "http://localhost:3000/"
  end

  add_index "library_groups", ["short_name"], :name => "index_library_groups_on_short_name"

  create_table "participates", :force => true do |t|
    t.integer  "patron_id",  :null => false
    t.integer  "event_id",   :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participates", ["event_id"], :name => "index_participates_on_event_id"
  add_index "participates", ["patron_id"], :name => "index_participates_on_patron_id"

  create_table "patron_types", :force => true do |t|
    t.string   "name",         :null => false
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patrons", :force => true do |t|
    t.integer  "user_id"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "first_name"
    t.string   "last_name_transcription"
    t.string   "middle_name_transcription"
    t.string   "first_name_transcription"
    t.string   "corporate_name"
    t.string   "corporate_name_transcription"
    t.string   "full_name"
    t.text     "full_name_transcription"
    t.text     "full_name_alternative"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "zip_code_1"
    t.string   "zip_code_2"
    t.text     "address_1"
    t.text     "address_2"
    t.text     "address_1_note"
    t.text     "address_2_note"
    t.string   "telephone_number_1"
    t.string   "telephone_number_2"
    t.string   "fax_number_1"
    t.string   "fax_number_2"
    t.text     "other_designation"
    t.text     "place"
    t.string   "postal_code"
    t.text     "street"
    t.text     "locality"
    t.text     "region"
    t.datetime "date_of_birth"
    t.datetime "date_of_death"
    t.integer  "language_id",                  :default => 1, :null => false
    t.integer  "country_id",                   :default => 1, :null => false
    t.integer  "patron_type_id",               :default => 1, :null => false
    t.integer  "lock_version",                 :default => 0, :null => false
    t.text     "note"
    t.integer  "creates_count",                :default => 0, :null => false
    t.integer  "realizes_count",               :default => 0, :null => false
    t.integer  "produces_count",               :default => 0, :null => false
    t.integer  "owns_count",                   :default => 0, :null => false
    t.integer  "required_role_id",             :default => 1, :null => false
    t.integer  "required_score",               :default => 0, :null => false
    t.string   "state"
    t.text     "email"
    t.text     "url"
  end

  add_index "patrons", ["country_id"], :name => "index_patrons_on_country_id"
  add_index "patrons", ["full_name"], :name => "index_patrons_on_full_name"
  add_index "patrons", ["language_id"], :name => "index_patrons_on_language_id"
  add_index "patrons", ["required_role_id"], :name => "index_patrons_on_required_role_id"
  add_index "patrons", ["user_id"], :name => "index_patrons_on_user_id", :unique => true

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shelves", :force => true do |t|
    t.string   "name",                        :null => false
    t.text     "display_name"
    t.text     "note"
    t.integer  "library_id",   :default => 1, :null => false
    t.integer  "items_count",  :default => 0, :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "shelves", ["library_id"], :name => "index_shelves_on_library_id"

  create_table "user_groups", :force => true do |t|
    t.string   "name"
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_has_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "user_group_id"
    t.integer  "required_role_id"
    t.string   "username"
    t.text     "note"
    t.string   "locale"
    t.string   "user_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
