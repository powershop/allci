require 'rails_helper'

RSpec.describe AssignTask do
  let(:service) { AssignTask.new(build_id: build_id, stage: stage, runner_name: runner_name) }
  let(:runner_name) { "foo-1234:1" }

  let(:project) { Project.create!(name: "Test project") }
  let(:configuration) { project.configurations.create!(name: "Standard build", build_priority: 100) }
  let(:repository) { Repository.create!(uri: "git@github.com:willbryant/demo_project.git") }

  context "when no build is specified" do
    let(:build_id) { nil }
    let(:stage) { "bootstrap" }
    let(:build) { EnqueueConfigurationBuild.new(configuration).call({}) }
    let(:task) { build.build_tasks.take }

    before do
      expect(task.state).to eq("available")
    end

    it "assigns tasks created by the EnqueueConfigurationBuild service" do
      expect(service.call).to eq(task)

      task.reload
      expect(task.state).to eq("running")
      expect(task.workers_to_run).to eq(0)
      expect(task.build_task_runs.size).to eq(1)
      expect(task.build_task_runs.first.state).to eq("running")
      expect(task.build_task_runs.first.started_at).not_to be_blank
      expect(task.build_task_runs.first.runner.name).to eq(runner_name)
    end

    it "reassigns tasks that the runner was supposedly already running" do
      service.call
      task.reload
      expect(task.state).to eq("running")

      expect(service.call).to eq(task)

      task.reload
      expect(task.state).to eq("running")
      expect(task.workers_to_run).to eq(0)
      expect(task.build_task_runs.size).to eq(2)
      expect(task.build_task_runs.first.state).to eq("aborted")
      expect(task.build_task_runs.first.started_at).not_to be_blank
      expect(task.build_task_runs.first.finished_at).not_to be_blank
      expect(task.build_task_runs.first.runner.name).to eq(runner_name)
      expect(task.build_task_runs.last.state).to eq("running")
      expect(task.build_task_runs.last.started_at).not_to be_blank
      expect(task.build_task_runs.last.runner.name).to eq(runner_name)
    end
  end
end
