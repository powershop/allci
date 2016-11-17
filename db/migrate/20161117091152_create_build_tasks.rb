class CreateBuildTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :build_tasks do |t|
      t.integer  :configuration_build_id, null: false
      t.string   :state, null: false, default: 'queued'
      t.string   :stage, null: false
      t.string   :task
      t.integer  [:configuration_build_id, :stage, :state], name: "index_tasks_by_build"
      t.string   [:state, :task], name: "index_tasks_by_state"
      t.timestamps
    end
  end
end
