class TasksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def pull
    @task = AssignTask.new(build_id: params["build_id"].presence, stage: params["stage"].presence, runner_name: params["runner_name"]).call
    if @task
      render json: @task
    else
      head :no_content
    end
  end

  def output
    StoreTaskOutput.new(
      task_id: params["task_id"],
      runner_name: params["runner_name"],
      output: params["output"].permit!.to_h,
    ).call
    head :ok
  end

  def success
    complete
  end

  def failed
    complete(failed: true)
  end

protected
  def complete(failed: false)
    CompleteTask.new(
      task_id: params["task_id"],
      runner_name: params["runner_name"],
      output: params["output"].permit!.to_h,
      exit_code: params["exit_code"].permit!.to_h,
      failed: failed,
    ).call
    head :ok
  end
end
