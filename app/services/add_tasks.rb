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
        build_tasks.create!(task: task, workers_to_run: @workers_to_run || 1)
      end
    end
  end

  def build_tasks
    BuildTask.for_build(@build_id).for_stage(@stage)
  end
end
