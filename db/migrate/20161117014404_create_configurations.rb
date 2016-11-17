class CreateConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :configurations do |t|
      t.integer  :project_id, null: false
      t.string   :name,       null: false
      t.integer  :build_priority
      t.index    [:project_id, :name], unique: true, name: "index_project_configuration_by_name"
      t.index    [:project_id, :build_priority], name: "index_project_configurations_by_priority"
      t.timestamps
    end
  end
end
