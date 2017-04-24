class ConfigurationBuild < ApplicationRecord
  belongs_to :configuration
  belongs_to :triggered_by_repository, class_name: 'Repository', optional: true
  has_many :build_tasks
  has_many :build_task_runs, through: :build_tasks
  has_many :build_task_run_outputs, through: :build_task_runs

  delegate :project, to: :configuration

  STATES = %w(available running failed success)
  STATES.each { |state| scope state, -> { where(state: state) } }
  validates_inclusion_of :state, in: STATES

  def image_name_for(component)
    "#{Registry.host_prefix}#{project.name.downcase.tr('^A-Za-z0-9_', '_')}-#{component.container_name}:build-#{id}"
  end
end
