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

ActiveRecord::Schema.define(version: 20161117091152) do

  create_table "build_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "configuration_build_id",                                       null: false
    t.string   "state",                                     default: "queued", null: false
    t.string   "stage",                                                        null: false
    t.string   "task"
    t.integer  "[:configuration_build_id, :stage, :state]"
    t.string   "[:state, :task]"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
  end

  create_table "component_variables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "component_id", null: false
    t.string   "name",         null: false
    t.string   "value"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["component_id", "name"], name: "index_component_variables_on_component_id_and_name", using: :btree
  end

  create_table "components", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "configuration_id",                        null: false
    t.integer  "repository_id",                           null: false
    t.string   "branch",           default: "master",     null: false
    t.string   "dockerfile",       default: "Dockerfile", null: false
    t.string   "container_name",                          null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["configuration_id", "container_name"], name: "index_configuration_components_by_name", unique: true, using: :btree
    t.index ["configuration_id", "repository_id", "branch"], name: "index_configuration_components_by_repository", using: :btree
  end

  create_table "configuration_builds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "configuration_id",                              null: false
    t.string   "state",                      default: "queued", null: false
    t.integer  "triggered_by_repository_id"
    t.string   "triggered_by_commit"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.index ["configuration_id", "state"], name: "index_configuration_builds_by_configuration", using: :btree
    t.index ["state"], name: "index_configuration_builds_by_state", using: :btree
  end

  create_table "configurations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "project_id",     null: false
    t.string   "name",           null: false
    t.integer  "build_priority"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["project_id", "build_priority"], name: "index_project_configurations_by_priority", using: :btree
    t.index ["project_id", "name"], name: "index_project_configuration_by_name", unique: true, using: :btree
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",            null: false
    t.integer  "created_by_user"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "repositories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.string   "uri",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uri"], name: "index_repositories_on_uri", unique: true, using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

end
