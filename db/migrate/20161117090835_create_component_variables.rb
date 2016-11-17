class CreateComponentVariables < ActiveRecord::Migration[5.0]
  def change
    create_table :component_variables do |t|
      t.integer  :component_id, null: false
      t.string   :name,         null: false
      t.string   :value
      t.index    [:component_id, :name]
      t.timestamps
    end
  end
end
