class BurndownsController < ApplicationController
  def show
    build = params[:config_build_id] ? ConfigurationBuild.find(params[:config_build_id]) : ConfigurationBuild.last
    start_time = build.build_task_runs.minimum(:started_at)
    end_time   = build.build_task_runs.maximum(:finished_at)

    @build_task_runs = build.build_task_runs
    @configuration_build_id = build.id

    runtime = (end_time || Time.now) - start_time
    @configuration_data = { running: end_time.nil?, runtime: runtime, build_id: @configuration_build_id }

    duration = params[:scale] ? params[:scale].to_d.minutes : runtime

    @timeframe = start_time..(start_time + duration)
    @scale_time = @timeframe.max - @timeframe.min

    runs_by_runner_and_config = Projected.burndown_rows_for_timeframe(build, @timeframe).group_by { |run| [run.name, run.configuration_build_id] }

    @data = {}
    runs_by_runner_and_config.each do |(runner, config), runs|
      runs_by_stage = runs.group_by(&:stage)

      @data[runner] ||= {}
      @data[runner][config] = runs_by_stage
    end
  end

  private

  class Projected
    def self.burndown_rows_for_timeframe(framing_config, timeframe)
      earliest_start = framing_config.build_task_runs.minimum(:started_at)

      runs    = BuildTaskRun.arel_table
      builds  = ConfigurationBuild.arel_table
      runners = Runner.arel_table

      build_alias = builds[:id].as('configuration_build_id')
      duration_alias = Arel::Nodes::NamedFunction.new(
        'TIMESTAMPDIFF',
        [
          Arel::Nodes::SqlLiteral.new('SECOND'),
          runs[:started_at],
          runs[:finished_at]
        ]
      ).as('duration')
      relative_start = Arel::Nodes::NamedFunction.new(
        'TIMESTAMPDIFF',
        [
          Arel::Nodes::SqlLiteral.new('SECOND'),
          Arel::Nodes::Quoted.new(earliest_start),
          runs[:started_at],
        ]
      )
      string_start = Arel::Nodes::NamedFunction.new(
        'CAST',
        [
          runs[:started_at].as('CHAR')
        ]
      ).as('raw_started_at')

      pluckables = [ :id, duration_alias, :state, :stage, :task, :name, build_alias, relative_start, string_start ] # aligned with struct definition

      raw_data = BuildTaskRun.
        where(started_at: timeframe).
        left_joins(:runner, {build_task: :configuration_build}).
        order(runners[:name]).
        pluck(*pluckables)

      raw_data.map { |row| BurndownRow.new(*row) }
    end

    BurndownRow = Struct.new(:id, :duration, :state, :stage, :task, :name, :configuration_build_id, :relative_start, :started_at) do
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
