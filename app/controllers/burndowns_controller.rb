class BurndownsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    start_time = build_task_runs.minimum(:started_at)
    end_time   = build_task_runs.maximum(:finished_at)

    runtime = (end_time || Time.now) - start_time
    @configuration_data = { running: end_time.nil?, runtime: runtime, build_id: @configuration_build_id }

    duration = params[:scale] ? params[:scale].to_d.minutes : runtime

    @timeframe = start_time..(start_time + duration)

    runs_by_runner_and_config = BuildTaskRun.
      where(started_at: @timeframe).
      order("runners.name").
      left_joins(:runner, :configuration_build, :build_task).
      select('build_task_runs.*, build_tasks.stage AS inferred_stage').
      includes(:runner, :configuration_build)

    puts "len calc"
    puts (Benchmark.ms do
      puts "len: #{runs_by_runner_and_config.to_a.length}"
    end)

    puts "group_by calc"
    puts (Benchmark.ms do
      runs_by_runner_and_config = runs_by_runner_and_config.group_by { |run| [run.runner, run.configuration_build] }
    end)

    @data = {}
    runs_by_runner_and_config.each do |(runner, config), runs|
      runs_by_stage = runs.group_by do |run|
        run.inferred_stage
      end

      @data[runner] ||= {}
      @data[runner][config] = runs_by_stage
    end
  end

  private

  def build_task_runs
    return @build_task_runs if @build_task_runs

    build = params[:config_build_id] ? ConfigurationBuild.find(params[:config_build_id]) : ConfigurationBuild.last

    @configuration_build_id = build.id
    @build_task_runs = build.build_task_runs
  end
end