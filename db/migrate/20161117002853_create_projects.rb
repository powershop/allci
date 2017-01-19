class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string   :name, null: false
      t.integer  :created_by_user
      t.timestamps
      t.index    :name, unique: true
    end
  end
end
