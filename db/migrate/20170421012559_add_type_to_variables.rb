class AddTypeToVariables < ActiveRecord::Migration[5.0]
  def change
    add_column   :component_variables, :variable_type, :string, limit: 32, null: false, default: 'runtime_env'
    add_index    :component_variables, [:component_id, :variable_type, :name], unique: true, name: 'index_component_variables_by_type_and_name'
    remove_index :component_variables, name: 'index_component_variables_on_component_id_and_name'
  end
end
