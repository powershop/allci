class CreateBuildTaskRunOutputs < ActiveRecord::Migration[5.0]
  def change
    create_table :build_task_run_outputs do |t|
      t.integer  :build_task_run_id,      null: false
      t.string   :container_name,         null: false
      t.text     :output, limit: 2**24-1, null: false
      t.integer  :exit_code
      t.timestamps
      t.index    [:build_task_run_id, :container_name], name: "index_build_task_run_outputs_on_container", unique: true
      t.index    :created_at # can be used to purge old output data, as it will grow large over time
    end
    if connection.class.name =~ /mysql/i
      execute "ALTER TABLE build_task_run_outputs ROW_FORMAT=COMPRESSED, KEY_BLOCK_SIZE=4"
    end
  end
end
