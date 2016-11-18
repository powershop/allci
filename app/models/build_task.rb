class BuildTask < ApplicationRecord
  belongs_to :configuration_build
  has_many :build_task_runs

  scope :queued, -> { where(state: "queued") }
  scope :for_stage, -> (stage) { where(stage: stage) }
end
