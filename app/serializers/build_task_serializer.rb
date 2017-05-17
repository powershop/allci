class BuildTaskSerializer < ActiveModel::Serializer
  attributes :id, :state
  belongs_to :configuration_build
end
