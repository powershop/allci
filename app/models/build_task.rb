class BuildTask < ApplicationRecord
  belongs_to :configuration_build
  has_many :build_task_runs
  has_one :running_task_run, -> { running }, class_name: 'BuildTaskRun'

  scope :available, -> { where(state: "available") }
  scope :running, -> { where(state: "running") }

  scope :for_stage, -> (stage) { where(stage: stage) }

  def as_json(options)
    {
      task_id: id,
      stage: stage,
      task: task,
      components: configuration_build.configuration.components.as_json(except: [:created_at, :updated_at]),
    }
  end
end
