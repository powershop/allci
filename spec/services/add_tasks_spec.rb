require 'rails_helper'

RSpec.describe AddTasks do
  let(:project) { Project.create!(name: "Test project") }
  let(:configuration) { project.configurations.create!(name: "Standard build", build_priority: 100) }
  let(:repository) { Repository.create!(uri: "git@github.com:willbryant/demo_project.git") }
  let(:build) { EnqueueConfigurationBuild.new(configuration).call({}) }

  let(:service) { AddTasks.new(build_id: build.id, stage: stage, tasks: tasks, workers_to_run: workers_to_run) }

  context "with just a list of tasks" do
    let(:workers_to_run) { nil }
    let(:stage) { "second_stage" }
    let(:tasks) { ["task 1", "second task"] }

    it "creates tasks under the given build" do
      service.call

      expect(build.build_tasks.where(stage: stage).size).to eq(2)
      expect(build.build_tasks.where(stage: stage).collect(&:task).sort).to eq(tasks.sort)
      expect(build.build_tasks.where(stage: stage).collect(&:workers_to_run)).to eq([1]*tasks.size)
    end
  end

  context "with a number of workers to run specified" do
    let(:workers_to_run) { 20 }
    let(:stage) { "load_test" }
    let(:tasks) { ["server-goes-here:3000"] }

    it "creates a task with the given number of workers" do
      service.call

      expect(build.build_tasks.where(stage: stage).size).to eq(1)
      expect(build.build_tasks.where(stage: stage).first.task).to eq(tasks.first)
      expect(build.build_tasks.where(stage: stage).first.workers_to_run).to eq(20)
    end
  end
end
