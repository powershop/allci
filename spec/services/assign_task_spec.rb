require 'rails_helper'

RSpec.describe AssignTask do
  let(:service) { AssignTask.new(build_id: build_id, stage: stage, runner_id: runner_id) }
  let(:runner_id) { "foo-1234:1" }

  let(:project) { Project.create!(name: "Test project") }
  let(:configuration) { project.configurations.create!(name: "Standard build", build_priority: 100) }
  let(:repository) { Repository.create!(uri: "git@github.com:willbryant/demo_project.git") }

  context "for the generic 'containers' ID" do
    let(:build_id) { "containers" }
    let(:stage) { "build_component_images" }

    it "assigns tasks created by the EnqueueConfigurationBuild service" do
      build = EnqueueConfigurationBuild.new(configuration).call({})
      task = build.build_tasks.take
      expect(task.state).to eq("queued")

      service.call

      task.reload
      expect(task.state).to eq("running")
      expect(task.build_task_runs.size).to eq(1)
      expect(task.build_task_runs.first.started_at).not_to be_blank
      expect(task.build_task_runs.first.runner.name).to eq(runner_id)
    end
  end
end
