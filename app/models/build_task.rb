class BuildTask < ApplicationRecord
  belongs_to :configuration_build
  has_many :build_task_runs
  has_one :running_task_run, -> { running }, class_name: 'BuildTaskRun'

  scope :queued, -> { where(state: "queued") }
  scope :running, -> { where(state: "running") }

  scope :for_stage, -> (stage) { where(stage: stage) }
end
