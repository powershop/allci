class CreateBuildTaskRuns < ActiveRecord::Migration[5.0]
  def change
    create_table :build_task_runs do |t|
      t.integer  :build_task_id, null: false
      t.string   :state,         null: false, default: "running"
      t.integer  :runner_id,     null: false
      t.datetime :started_at,    null: false
      t.datetime :finished_at
      t.text     :output, limit: 2**24-1
      t.index    [:build_task_id, :state], name: "index_build_task_runs_by_build_task"
      t.index    [:runner_id, :build_task_id], name: "index_build_task_runs_by_runner"
      t.timestamps
    end
  end
end
