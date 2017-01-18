class BuildTask < ApplicationRecord
  belongs_to :configuration_build
  has_many :build_task_runs
  has_one :running_task_run, -> { running }, class_name: 'BuildTaskRun'

  scope :available, -> { where(state: "available") }
  scope :running, -> { where(state: "running") }

  scope :for_stage, -> (stage) { where(stage: stage) }

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
        }
      }
    }
  end
end
