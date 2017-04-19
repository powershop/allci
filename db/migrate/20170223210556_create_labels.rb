class CreateLabels < ActiveRecord::Migration[5.0]
  def change
    create_table :labels do |t|
      t.string :name, limit: 64, required: true
      t.integer :project_labels_count, default: 0
      t.index :name, unique: true
    end
  end
end
