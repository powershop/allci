class BuildTaskRun < ApplicationRecord
  belongs_to :build_task
  belongs_to :runner

  validates_presence_of :started_at

  scope :running, -> { where(state: "running") }
  scope :running_on, -> (runner_name) { joins(:runner).where('runners.name' => runner_name) }
end
