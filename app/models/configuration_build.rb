class ConfigurationBuild < ApplicationRecord
  belongs_to :configuration
  belongs_to :triggered_by_repository, class_name: 'Repository', optional: true
  has_many :build_tasks
end
