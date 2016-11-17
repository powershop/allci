class CreateRepositories < ActiveRecord::Migration[5.0]
  def change
    create_table :repositories do |t|
      t.string   :name, null: false
      t.string   :uri,  null: false
      t.index    :uri, unique: true
      t.timestamps
    end
  end
end
