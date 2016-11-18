class CreateBuildTaskRuns < ActiveRecord::Migration[5.0]
  def change
    create_table :build_task_runs do |t|
      t.integer  :build_task_id, null: false
      t.string   :state,         null: false, default: "assigned"
      t.integer  :runner_id,     null: false
      t.datetime :started_at,    null: false
      t.datetime :finished_at
      t.index    [:build_task_id, :state], name: "index_build_task_runs_by_build_task"
      t.timestamps
    end
  end
end
