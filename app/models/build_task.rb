class BuildTask < ApplicationRecord
  belongs_to :configuration_build
  has_many :build_task_runs

  scope :available, -> { where(state: "available") }
  scope :running, -> { where(state: "running") }

  scope :for_stage, -> (stage) { where(stage: stage) }
  scope :for_build, -> (build_id) { where(configuration_build_id: build_id) }

  STATES = %w(available running failed success)
  STATES.each { |state| scope state, -> { where(state: state) } }
  validates_inclusion_of :state, in: STATES

  def as_json(options = nil)
    {
      task_id: id,
      stage: stage,
      task: task,
      workers_to_run: workers_to_run,
      configuration_name: configuration_build.configuration.name,
      components: configuration_build.configuration.components.order(:container_name).each_with_object({}) { |component, results|
        results[component.container_name] = {
          repository_name: component.repository.name,
          repository_uri: component.repository.uri,
          branch: component.branch,
          dockerfile: component.dockerfile,
          image_name: configuration_build.image_name_for(component),
          env: component.component_variables.each_with_object({}) { |cv, results| results[cv.name] = cv.value },
        }
      }
    }
  end

  def complete?
    %w(failed success).include?(state)
  end
end
