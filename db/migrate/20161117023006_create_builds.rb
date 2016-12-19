class CreateBuilds < ActiveRecord::Migration[5.0]
  def change
    create_table :configuration_builds do |t|
      t.integer  :configuration_id, null: false
      t.string   :state, null: false, default: "available"
      t.integer  :triggered_by_repository_id
      t.string   :triggered_by_commit
      t.index    :state, name: "index_configuration_builds_by_state"
      t.index    [:configuration_id, :state], name: "index_configuration_builds_by_configuration"
      t.timestamps
    end
  end
end
