class AssignTask
  def initialize(build_id:, stage:, runner_id:)
    @build_id =  build_id
    @stage = stage
    @runner_id = runner_id
  end

  def call
    BuildTask.transaction do
      task = available_build_tasks.lock.take
      if task
        task.update!(state: "running")
        task.build_task_runs.create!(runner: runner, started_at: Time.now)
      end
      task
    end
  end

  def available_build_tasks
    scope = BuildTask.queued.for_stage(@stage)

    case @build_id
    when nil
      scope.joins(:configuration_build => :configuration).merge(Configuration.in_build_priority_order)
    else
      scope.for_build(@build_id)
    end
  end

  def runner
    Runner.find_by_name(@runner_id) || Runner.create!(name: @runner_id)
  rescue ActiveRecord::RecordNotUnique
    retry
  end
end
