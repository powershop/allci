class ConfigurationBuildSerializer < ActiveModel::Serializer
  attributes :id, :state
  belongs_to :configuration
  has_many :build_tasks
end
