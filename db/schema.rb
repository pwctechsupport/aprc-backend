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

ActiveRecord::Schema.define(version: 2019_11_28_053054) do

  create_table "business_processes", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.index ["ancestry"], name: "index_business_processes_on_ancestry"
  end

  create_table "it_systems", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "policies", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "policy_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "ancestry"
    t.index ["ancestry"], name: "index_policies_on_ancestry"
    t.index ["policy_category_id"], name: "index_policies_on_policy_category_id"
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

  create_table "references", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resources", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "policies", "policy_categories"
  add_foreign_key "policies", "users"
  add_foreign_key "policy_business_processes", "business_processes"
  add_foreign_key "policy_business_processes", "policies"
  add_foreign_key "policy_it_systems", "it_systems"
  add_foreign_key "policy_it_systems", "policies"
  add_foreign_key "policy_references", "policies"
  add_foreign_key "policy_references", "references"
  add_foreign_key "policy_resources", "policies"
  add_foreign_key "policy_resources", "resources"
end
