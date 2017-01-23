class StoreTaskOutput
  def initialize(task_id:, runner_name:, output:)
    @task_id = task_id
    @runner_name = runner_name
    @output = output
  end

  def call
    BuildTask.transaction do
      store_output
      task
    end
  end

protected
  def task
    @task ||= BuildTask.lock.find(@task_id)
  end

  def task_run
    @task_run ||= task.build_task_runs.running.running_on(@runner_name).take!
  end

  def store_output
    records = task_run.build_task_run_outputs.index_by(&:container_name)
    @output.each do |container_name, new_output|
      record = records[container_name] || task_run.build_task_run_outputs.build(container_name: container_name, output: '')
      record.output += new_output
      record.save!
    end
  end
end
