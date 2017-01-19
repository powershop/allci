class CompleteTask
  def initialize(task_id:, runner_name:, output:, failed:)
    @task_id = task_id
    @runner_name = runner_name
    @output = output
    @failed = failed
  end

  def call
    BuildTask.transaction do
      task_run.finished_at = Time.now
      task_run.output = @output
      task_run.state = @failed ? "failed" : "success"
      task_run.save!

      if !task.complete?
        if @failed
          task.state = "failed"
        elsif task.build_task_runs.running.present?
          task.state = "running"
        else
          task.state = "success"
        end
      end
      task.save!
      task
    end
  end

  def task
    @task ||= BuildTask.lock.find(@task_id)
  end

  def task_run
    @task_run ||= task.build_task_runs.running.running_on(@runner_name).take!
  end
end
