class CreateComponents < ActiveRecord::Migration[5.0]
  def change
    create_table :components do |t|
      t.integer  :configuration_id, null: false
      t.integer  :repository_id,    null: false
      t.string   :branch,           null: false, default: 'master'
      t.boolean  :triggers_builds,  null: false, default: true
      t.string   :dockerfile,       null: false, default: 'Dockerfile'
      t.string   :container_name,   null: false
      t.string   :tmpfs
      t.index    [:configuration_id, :repository_id, :branch, :triggers_builds], name: "index_configuration_components_by_repository"
      t.index    [:configuration_id, :container_name], unique: true, name: "index_configuration_components_by_name"
      t.timestamps
    end
  end
end
