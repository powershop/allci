class CreateProjectLabels < ActiveRecord::Migration[5.0]
  def change
    create_table :project_labels do |t|
      t.belongs_to :project
      t.belongs_to :label
      t.index [:project_id, :label_id], unique: true
      t.index [:label_id, :project_id], unique: true
    end
  end
end
