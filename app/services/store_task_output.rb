class StoreTaskOutput
  def initialize(task_id:, runner_name:, output:)
    @task_id = task_id
    @runner_name = runner_name
    @output = output
  end

  def call
    BuildTask.transaction do
      store_output
      task_run.save!
    end
  end

protected
  def task
    @task ||= BuildTask.lock.find(@task_id)
  end

  def task_run
    @task_run ||= task.build_task_runs.running.running_on(@runner_name).take!
  end

  def output_for(container_name)
    @output_records ||= task_run.build_task_run_outputs.index_by(&:container_name)
    @output_records[container_name] ||= task_run.build_task_run_outputs.build(container_name: container_name, output: '')
  end

  def store_output
    @output.each do |container_name, new_output|
      output_for(container_name).output += new_output
    end
  end
end
