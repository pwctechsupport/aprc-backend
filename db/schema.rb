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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_07_095954) do

  create_table "bookmark_business_processes", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "business_process_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_process_id"], name: "index_bookmark_business_processes_on_business_process_id"
    t.index ["user_id"], name: "index_bookmark_business_processes_on_user_id"
  end

  create_table "bookmark_controls", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "control_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["control_id"], name: "index_bookmark_controls_on_control_id"
    t.index ["user_id"], name: "index_bookmark_controls_on_user_id"
  end

  create_table "bookmark_policies", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "policy_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["policy_id"], name: "index_bookmark_policies_on_policy_id"
    t.index ["user_id"], name: "index_bookmark_policies_on_user_id"
  end

  create_table "bookmark_risks", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "risk_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["risk_id"], name: "index_bookmark_risks_on_risk_id"
    t.index ["user_id"], name: "index_bookmark_risks_on_user_id"
  end

  create_table "bookmarks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.string "originator_type"
    t.integer "originator_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "business_processes", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.string "status"
    t.index ["ancestry"], name: "index_business_processes_on_ancestry"
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "control_business_processes", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "control_id"
    t.bigint "business_process_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_process_id"], name: "index_control_business_processes_on_business_process_id"
    t.index ["control_id"], name: "index_control_business_processes_on_control_id"
  end

  create_table "control_descriptions", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "control_id"
    t.bigint "description_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["control_id"], name: "index_control_descriptions_on_control_id"
    t.index ["description_id"], name: "index_control_descriptions_on_description_id"
  end

  create_table "control_risks", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "control_id"
    t.bigint "risk_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["control_id"], name: "index_control_risks_on_control_id"
    t.index ["risk_id"], name: "index_control_risks_on_risk_id"
  end

  create_table "controls", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "type_of_control"
    t.text "frequency"
    t.text "nature"
    t.text "assertion"
    t.text "ipo"
    t.text "control_owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "draft"
    t.boolean "key_control", default: false, null: false
    t.string "description"
  end

  create_table "descriptions", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drafts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.text "previous_draft"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "object_changes"
    t.index ["created_at"], name: "index_drafts_on_created_at"
    t.index ["event"], name: "index_drafts_on_event"
    t.index ["item_id"], name: "index_drafts_on_item_id"
    t.index ["item_type"], name: "index_drafts_on_item_type"
    t.index ["updated_at"], name: "index_drafts_on_updated_at"
    t.index ["whodunnit"], name: "index_drafts_on_whodunnit"
  end

  create_table "it_systems", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.text "body"
    t.string "originator_type"
    t.integer "originator_id"
    t.boolean "is_read", default: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sender_user_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "policies", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "policy_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "ancestry"
    t.string "status", default: "draft"
    t.integer "visit", default: 0
    t.bigint "resource_id"
    t.integer "draft_id"
    t.timestamp "published_at"
    t.timestamp "trashed_at"
    t.integer "user_reviewer_id"
    t.index ["ancestry"], name: "index_policies_on_ancestry"
    t.index ["policy_category_id"], name: "index_policies_on_policy_category_id"
    t.index ["resource_id"], name: "index_policies_on_resource_id"
    t.index ["user_id"], name: "index_policies_on_user_id"
  end

  create_table "policy_business_processes", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "policy_id"
    t.bigint "business_process_id"
    t.index ["business_process_id"], name: "index_policy_business_processes_on_business_process_id"
    t.index ["policy_id"], name: "index_policy_business_processes_on_policy_id"
  end

  create_table "policy_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_policy_category_id"
  end

  create_table "policy_controls", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "policy_id"
    t.bigint "control_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["control_id"], name: "index_policy_controls_on_control_id"
    t.index ["policy_id"], name: "index_policy_controls_on_policy_id"
  end

  create_table "policy_it_systems", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "policy_id"
    t.bigint "it_system_id"
    t.index ["it_system_id"], name: "index_policy_it_systems_on_it_system_id"
    t.index ["policy_id"], name: "index_policy_it_systems_on_policy_id"
  end

  create_table "policy_references", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "policy_id"
    t.bigint "reference_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["policy_id"], name: "index_policy_references_on_policy_id"
    t.index ["reference_id"], name: "index_policy_references_on_reference_id"
  end

  create_table "policy_resources", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "policy_id"
    t.bigint "resource_id"
    t.index ["policy_id"], name: "index_policy_resources_on_policy_id"
    t.index ["resource_id"], name: "index_policy_resources_on_resource_id"
  end

  create_table "policy_risks", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "policy_id"
    t.bigint "risk_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["policy_id"], name: "index_policy_risks_on_policy_id"
    t.index ["risk_id"], name: "index_policy_risks_on_risk_id"
  end

  create_table "references", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
  end

  create_table "resource_controls", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "resource_id"
    t.bigint "control_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["control_id"], name: "index_resource_controls_on_control_id"
    t.index ["resource_id"], name: "index_resource_controls_on_resource_id"
  end

  create_table "resource_ratings", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "resource_id"
    t.float "rating"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_resource_ratings_on_resource_id"
    t.index ["user_id"], name: "index_resource_ratings_on_user_id"
  end

  create_table "resources", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "resupload_file_name"
    t.string "resupload_content_type"
    t.bigint "resupload_file_size"
    t.datetime "resupload_updated_at"
    t.bigint "policy_id"
    t.bigint "control_id"
    t.bigint "business_process_id"
    t.bigint "policy_id_id_id"
    t.bigint "policy_id_id"
    t.string "category"
    t.integer "visit", default: 0
    t.string "status"
    t.index ["business_process_id"], name: "index_resources_on_business_process_id"
    t.index ["control_id"], name: "index_resources_on_control_id"
    t.index ["policy_id"], name: "index_resources_on_policy_id"
    t.index ["policy_id_id"], name: "index_resources_on_policy_id_id"
    t.index ["policy_id_id_id"], name: "index_resources_on_policy_id_id_id"
  end

  create_table "risks", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "level_of_risk"
    t.string "status", default: "draft"
    t.bigint "business_process_id", default: 0
    t.string "type_of_risk"
    t.index ["business_process_id"], name: "index_risks_on_business_process_id"
  end

  create_table "roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "user_policy_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "policy_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "jti", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.integer "role"
    t.string "phone"
    t.string "department"
    t.string "job_position"
    t.integer "draft_id"
    t.timestamp "published_at"
    t.timestamp "trashed_at"
    t.integer "user_reviewer_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "version_associations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.string "foreign_type"
    t.index ["foreign_key_name", "foreign_key_id", "foreign_type"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 4294967295
    t.datetime "created_at"
    t.text "object_changes", limit: 4294967295
    t.integer "transaction_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

  add_foreign_key "bookmark_business_processes", "business_processes"
  add_foreign_key "bookmark_business_processes", "users"
  add_foreign_key "bookmark_controls", "controls"
  add_foreign_key "bookmark_controls", "users"
  add_foreign_key "bookmark_policies", "policies"
  add_foreign_key "bookmark_policies", "users"
  add_foreign_key "bookmark_risks", "risks"
  add_foreign_key "bookmark_risks", "users"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "control_business_processes", "business_processes"
  add_foreign_key "control_business_processes", "controls"
  add_foreign_key "control_descriptions", "controls"
  add_foreign_key "control_descriptions", "descriptions"
  add_foreign_key "control_risks", "controls"
  add_foreign_key "control_risks", "risks"
  add_foreign_key "notifications", "users"
  add_foreign_key "policies", "policy_categories"
  add_foreign_key "policies", "resources"
  add_foreign_key "policies", "users"
  add_foreign_key "policy_business_processes", "business_processes"
  add_foreign_key "policy_business_processes", "policies"
  add_foreign_key "policy_controls", "controls"
  add_foreign_key "policy_controls", "policies"
  add_foreign_key "policy_it_systems", "it_systems"
  add_foreign_key "policy_it_systems", "policies"
  add_foreign_key "policy_references", "policies"
  add_foreign_key "policy_references", "references"
  add_foreign_key "policy_resources", "policies"
  add_foreign_key "policy_resources", "resources"
  add_foreign_key "policy_risks", "policies"
  add_foreign_key "policy_risks", "risks"
  add_foreign_key "resource_controls", "controls"
  add_foreign_key "resource_controls", "resources"
  add_foreign_key "resource_ratings", "resources"
  add_foreign_key "resource_ratings", "users"
  add_foreign_key "resources", "business_processes"
  add_foreign_key "resources", "controls"
  add_foreign_key "resources", "policies"
  add_foreign_key "risks", "business_processes"
end
