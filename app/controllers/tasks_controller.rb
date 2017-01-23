class TasksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def pull
    @task = AssignTask.new(build_id: params["task"]["build_id"].presence, stage: params["task"]["stage"].presence, runner_name: params["task"]["runner_name"]).call
    if @task
      render json: @task
    else
      head :no_content
    end
  end

  def success
    complete
  end

  def failed
    complete(failed: true)
  end

protected
  def complete(failed: false)
    CompleteTask.new(task_id: params["task"]["task_id"], runner_name: params["task"]["runner_name"], output: params["task"]["output"].permit!.to_h, failed: failed).call
    head :ok
  end
end
