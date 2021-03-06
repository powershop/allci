class BuildTaskRun < ApplicationRecord
  belongs_to :build_task
  belongs_to :runner
  has_one :configuration_build, through: :build_task
  has_many   :build_task_run_outputs, autosave: true

  validates_presence_of :started_at

  scope :running_on, -> (runner_name) { joins(:runner).where('runners.name' => runner_name) }

  STATES = %w(available running aborted failed success)
  STATES.each { |state| scope state, -> { where(state: state) } }
  validates_inclusion_of :state, in: STATES

  def duration
    return nil unless finished_at

    finished_at - started_at
  end

  def relative_start(start_time_of_build)
    started_at - start_time_of_build
  end

  def label
    if build_task.task
      build_task.task.split(' ').last + " (#{duration.to_i}s - #{started_at})" + " - ID #{id}"
    else
      "(#{duration.to_i}s - #{started_at})" + " - ID #{id}"
    end
  end

  def short_label
    return nil unless build_task.task

    build_task.task.split(' ').last.split('/').last + " (#{duration.to_i}s)"
  end
end
