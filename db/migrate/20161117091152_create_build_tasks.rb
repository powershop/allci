class CreateBuildTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :build_tasks do |t|
      t.integer  :configuration_build_id, null: false
      t.string   :state, null: false, default: "available"
      t.integer  :workers_to_run, null: false
      t.string   :stage, null: false
      t.string   :task
      t.index    [:configuration_build_id, :state, :stage], name: "index_tasks_by_build"
      t.index    [:state], name: "index_tasks_by_state"
      t.timestamps
    end
  end
end
