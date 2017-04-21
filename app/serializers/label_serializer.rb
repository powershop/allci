class LabelSerializer < ActiveModel::Serializer
  attributes :id, :name, :count

  def count
    object.project_labels_count
  end
end
