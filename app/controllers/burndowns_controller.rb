class BurndownsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    start_time = build_task_runs.minimum(:started_at)
    end_time   = build_task_runs.maximum(:finished_at)

    runtime = (end_time || Time.now) - start_time
    @configuration_data = { running: end_time.nil?, runtime: runtime, build_id: @configuration_build_id }

    duration = params[:scale] ? params[:scale].to_d.minutes : runtime

    @timeframe = start_time..(start_time + duration)

    runs_by_runner_and_config = Projected.burndown_rows_for_timeframe(@timeframe).group_by { |run| [run.name, run.configuration_build_id] }

    @data = {}
    runs_by_runner_and_config.each do |(runner, config), runs|
      runs_by_stage = runs.group_by(&:stage)

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

  class Projected
    PROJECTION = [
      %i[build_task_runs      id         ],
      %i[build_task_runs      started_at ],
      %i[build_task_runs      finished_at],
      %i[build_task_runs      state      ],
      %i[build_tasks          stage      ],
      %i[build_tasks          task       ],
      %i[runners              name       ],
      %i[configuration_builds id         configuration_build_id]
    ]

    def self.burndown_rows_for_timeframe(timeframe)
      retrieved_columns  = PROJECTION.map { |table, column, _| "`#{table}`.`#{column}`" }

      raw_data = BuildTaskRun.
        where(started_at: timeframe).
        left_joins(:runner, :configuration_build, :build_task).
        order('runners.name').
        pluck(*retrieved_columns)

      raw_data.map { |row| BurndownRow.new(*row) }
    end

    BurndownRow = Struct.new(*PROJECTION.map(&:last)) do
      def duration
        return nil unless finished_at

        finished_at - started_at
      end

      def relative_start(start_time_of_build)
        started_at - start_time_of_build
      end

      def label
        lead     = task&.split(' ')&.last
        duration = "(#{duration.to_i}s - #{started_at})" + " - ID #{id}"

        [lead, duration].compact.join(' ')
      end

      def short_label
        return nil unless task

        task.split(' ').last.split('/').last + " (#{duration.to_i}s)"
      end
    end
  end
end
