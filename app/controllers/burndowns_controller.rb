class BurndownsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    if params[:config_build_id]
      @configuration_build = ConfigurationBuild.find(params[:config_build_id])
    else
      @configuration_build = ConfigurationBuild.last
    end
    @build_task_runs = @configuration_build.build_task_runs.includes(:build_task)

    @start_time = @build_task_runs.min_by(&:started_at).started_at
    end_time = @build_task_runs.max_by(&:finished_at).finished_at

    @runtime = end_time - @start_time

    scale = if params[:scale]
              params[:scale].to_d.minutes
            else
              ((@runtime/60) + 1).to_i.minutes
            end

    @scale_time = scale

    @build_task_runs_by_runner = @build_task_runs.joins(:runner).order("runners.name").preload(:runner).group_by(&:runner)

    respond_to do |format|
      format.html { render layout: false}
    end
  end
end
