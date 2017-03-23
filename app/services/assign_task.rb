class AssignTask
  def initialize(build_id:, stage:, runner_name:)
    @build_id =  build_id
    @stage = stage
    @runner_name = runner_name
  end

  def call
    BuildTask.transaction do
      if task_run = task_run_to_retry
        task = task_run.build_task
        task_run.update!(state: "aborted", finished_at: Time.now) if task
      elsif task = available_build_tasks.lock.take
        task.workers_to_run -= 1
        task.state = "running" if task.workers_to_run < 1
        task.save!
      end
      task.build_task_runs.create!(runner: runner, started_at: Time.now) if task
      task
    end
  end

  def build_tasks
    if @build_id.nil?
      BuildTask.joins(:configuration_build => :configuration).merge(ConfigurationBuild.available).merge(Configuration.in_build_priority_order).for_stage(@stage)
    else
      BuildTask.for_build(@build_id).for_stage(@stage)
    end
  end

  def task_run_to_retry
    BuildTaskRun.running.running_on(@runner_name).joins(:build_task).merge(build_tasks).take
  end

  def available_build_tasks
    build_tasks.available
  end

  def runner
    Runner.find_by_name(@runner_name) || Runner.create!(name: @runner_name)
  rescue ActiveRecord::RecordNotUnique
    retry
  end
end
