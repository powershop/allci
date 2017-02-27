class AddTasks
  def initialize(build_id:, stage:, tasks:, workers_to_run:)
    @build_id =  build_id
    @stage = stage
    @tasks = tasks
    @workers_to_run = workers_to_run
  end

  def call
    BuildTask.transaction do
      @tasks.collect do |task|
        build_tasks_scope.create!(task: task, workers_to_run: @workers_to_run || 1)
      end
    end
  end

  def build
    ConfigurationBuild.find(@build_id)
  end

  def build_tasks_scope
    @build_tasks_scope ||= build.build_tasks.for_stage(@stage)
  end
end
