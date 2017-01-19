class ConfigurationBuild < ApplicationRecord
  belongs_to :configuration
  belongs_to :triggered_by_repository, class_name: 'Repository', optional: true
  has_many :build_tasks

  delegate :project, to: :configuration

  STATES = %w(available running finishing failed successful)
  STATES.each { |state| scope state, -> { where(state: state) } }
  validates_inclusion_of :state, in: STATES

  def image_name_for(component)
    "#{project.name.downcase.tr('^A-Za-z0-9_', '_')}-#{component.container_name}:build-#{id}"
  end
end
