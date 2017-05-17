class ConfigurationBuildsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @configuration_builds = ConfigurationBuild.all.order(:created_at)
    respond_to do |format|
      format.json { render json: @configuration_builds }
      format.html { render layout: 'simple' }
    end
  end

  def show
    @configuration_build = ConfigurationBuild.find(params[:id])
    @build_task_runs = @configuration_build.build_task_runs.includes(:build_task)

    @start_time = @build_task_runs.min_by(&:started_at).started_at
    end_time = @build_task_runs.max_by(&:finished_at).finished_at

    @runtime = end_time - @start_time

    @build_task_runs_by_runner = @build_task_runs.group_by(&:runner_id)

    respond_to do |format|
      format.html { render layout: false}
    end
  end
end
