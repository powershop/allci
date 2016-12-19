class AssignTask
  def initialize(build_id:, stage:, runner_name:)
    @build_id =  build_id
    @stage = stage
    @runner_name = runner_name
  end

  def call
    BuildTask.transaction do
      task = task_to_retry || available_build_tasks.lock.take
      if task
        task.update!(state: "running")
        task.build_task_runs.create!(runner: runner, started_at: Time.now)
      end
      task
    end
  end

  def build_tasks
    if @build_id.nil? && @stage.nil?
      BuildTask.joins(:configuration_build => :configuration).merge(ConfigurationBuild.available).merge(Configuration.in_build_priority_order)
    else
      BuildTask.for_build(@build_id).for_stage(@stage)
    end
  end

  def task_to_retry
    build_tasks.running.joins(:running_task_run).merge(BuildTaskRun.running_on(@runner_name)).take.tap do |task|
      task.running_task_run.update!(state: "aborted", finished_at: Time.now) if task
    end
  end

  def available_build_tasks
    build_tasks.queued
  end

  def runner
    Runner.find_by_name(@runner_name) || Runner.create!(name: @runner_name)
  rescue ActiveRecord::RecordNotUnique
    retry
  end
end
