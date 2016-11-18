class BuildTaskRun < ApplicationRecord
  belongs_to :build_task
  belongs_to :runner

  validates_presence_of :started_at
end
