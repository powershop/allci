class TasksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def pull
    @task = AssignTask.new(build_id: params["task"]["build_id"], stage: params["task"]["stage"], runner_name: params["task"]["runner_name"]).call
    if @task
      render json: @task
    else
      head :no_content
    end
  end
end