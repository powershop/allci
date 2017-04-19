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

ActiveRecord::Schema.define(version: 20170223210737) do

  create_table "build_task_run_outputs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=4" do |t|
    t.integer  "build_task_run_id",                  null: false
    t.string   "container_name",                     null: false
    t.text     "output",            limit: 16777215, null: false
    t.integer  "exit_code"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["build_task_run_id", "container_name"], name: "index_build_task_run_outputs_on_container", unique: true, using: :btree
    t.index ["created_at"], name: "index_build_task_run_outputs_on_created_at", using: :btree
  end

  create_table "build_task_runs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "build_task_id",                     null: false
    t.string   "state",         default: "running", null: false
    t.integer  "runner_id",                         null: false
    t.datetime "started_at",                        null: false
    t.datetime "finished_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["build_task_id", "state"], name: "index_build_task_runs_by_build_task", using: :btree
    t.index ["runner_id", "build_task_id"], name: "index_build_task_runs_by_runner", using: :btree
  end

  create_table "build_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "configuration_build_id",                       null: false
    t.string   "state",                  default: "available", null: false
    t.integer  "workers_to_run",                               null: false
    t.string   "stage",                                        null: false
    t.string   "task"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.index ["configuration_build_id", "state", "stage"], name: "index_tasks_by_build", using: :btree
    t.index ["state"], name: "index_tasks_by_state", using: :btree
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
    t.boolean  "triggers_builds",  default: true,         null: false
    t.string   "dockerfile",       default: "Dockerfile", null: false
    t.string   "container_name",                          null: false
    t.string   "tmpfs"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["configuration_id", "container_name"], name: "index_configuration_components_by_name", unique: true, using: :btree
    t.index ["configuration_id", "repository_id", "branch", "triggers_builds"], name: "index_configuration_components_by_repository", using: :btree
  end

  create_table "configuration_builds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "configuration_id",                                 null: false
    t.string   "state",                      default: "available", null: false
    t.integer  "triggered_by_repository_id"
    t.string   "triggered_by_commit"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
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

  create_table "labels", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name",                 limit: 64
    t.integer "project_labels_count",            default: 0
    t.index ["name"], name: "index_labels_on_name", unique: true, using: :btree
  end

  create_table "project_labels", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "project_id"
    t.integer "label_id"
    t.index ["label_id", "project_id"], name: "index_project_labels_on_label_id_and_project_id", unique: true, using: :btree
    t.index ["label_id"], name: "index_project_labels_on_label_id", using: :btree
    t.index ["project_id", "label_id"], name: "index_project_labels_on_project_id_and_label_id", unique: true, using: :btree
    t.index ["project_id"], name: "index_project_labels_on_project_id", using: :btree
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",            null: false
    t.integer  "created_by_user"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["name"], name: "index_projects_on_name", unique: true, using: :btree
  end

  create_table "repositories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.string   "uri",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uri"], name: "index_repositories_on_uri", unique: true, using: :btree
  end

  create_table "runners", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_runners_on_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

end
