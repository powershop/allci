require 'rails_helper'

RSpec.describe CompleteTask do
  let(:output) { {"container1" => "task output here", "container2" => "more output"} }
  let(:exit_code) { {"container1" => 0, "container2" => -127} }

  let(:project) { Project.create!(name: "Test project") }
  let(:configuration) { project.configurations.create!(name: "Standard build", build_priority: 100) }
  let(:repository) { Repository.create!(uri: "git@github.com:willbryant/demo_project.git") }
  let(:build) { EnqueueConfigurationBuild.new(configuration).call({}) }

  def expect_output_on(task_run)
    expect(task_run.build_task_run_outputs.size).to eq(2)

    container1 = task_run.build_task_run_outputs.find_by_container_name("container1")
    expect(container1.output).to eq("task output here")
    expect(container1.exit_code).to eq(0)

    container2 = task_run.build_task_run_outputs.find_by_container_name("container2")
    expect(container2.output).to eq("more output")
    expect(container2.exit_code).to eq(-127)
  end

  context "on single-worker tasks" do
    let(:runner_name) { "foo-1234:1" }
    let(:task) { AssignTask.new(build_id: nil, stage: "bootstrap", runner_name: runner_name).call }
    let(:service) { CompleteTask.new(task_id: task.id, runner_name: runner_name, output: output, exit_code: exit_code, failed: failed) }

    before do
      expect(build).not_to be_nil
      expect(task.state).to eq("running")
      expect(task.build_task_runs.size).to eq(1)
    end

    context "when it was a success" do
      let(:failed) { false }

      it "marks the task run successful and the task successful" do
        expect(service.call).to eq(task)

        task.reload
        expect(task.state).to eq("success")
        expect(task.build_task_runs.first.state).to eq("success")
        expect(task.build_task_runs.first.finished_at).not_to be_blank
        expect_output_on(task.build_task_runs.first)
      end

      context "no other available tasks in the build" do
        it "marks the build failed if any task failed" do
          build.build_tasks.create!(stage: "dummy", workers_to_run: 1, state: "failed")

          expect(service.call).to eq(task)

          expect(build.reload.state).to eq("failed")
        end

        it "marks the build successful otherwise" do
          expect(service.call).to eq(task)

          expect(build.reload.state).to eq("success")
        end
      end
    end

    context "when it was a failure" do
      let(:failed) { true }

      it "marks the task run failed and the task failed" do
        expect(service.call).to eq(task)

        task.reload
        expect(task.state).to eq("failed")
        expect(task.build_task_runs.first.state).to eq("failed")
        expect(task.build_task_runs.first.finished_at).not_to be_blank
        expect_output_on(task.build_task_runs.first)
      end

      context "no other available tasks in the build" do
        it "marks the build failed if any task failed" do
          expect(service.call).to eq(task)

          expect(build.reload.state).to eq("failed")
        end
      end
    end
  end

  context "on a multi-worker task" do
    before do
      expect(build).not_to be_nil
      expect(task.state).to eq("available")
      (0..2).each { |n| AssignTask.new(build_id: build.id, stage: "multi_worker_stuff", runner_name: runner_names[n]).call }
      expect(task.build_task_runs.size).to eq(3)
    end

    let(:runner_names) { (0..2).collect { |n| "foo-1234:#{n}" } }
    let(:task) { build.build_tasks.create!(stage: "multi_worker_stuff", workers_to_run: 10) }

    context "when it was a success" do
      let(:failed) { false }

      it "marks the task run successful and the task successful if there are no other runs running" do
        runner_names.each do |runner_name|
          expect(CompleteTask.new(task_id: task.id, runner_name: runner_name, output: output, exit_code: exit_code, failed: failed).call).to eq(task)
        end

        task.reload
        expect(task.state).to eq("success")
        expect(task.build_task_runs.last.state).to eq("success")
        expect(task.build_task_runs.last.finished_at).not_to be_blank
        expect_output_on(task.build_task_runs.last)
      end

      it "marks the task run successful and leaves the task running if there are still other runs running" do
        expect(CompleteTask.new(task_id: task.id, runner_name: runner_names.last, output: output, exit_code: exit_code, failed: failed).call).to eq(task)

        task.reload
        expect(task.state).to eq("running")
        expect(task.build_task_runs.last.state).to eq("success")
        expect(task.build_task_runs.last.finished_at).not_to be_blank
        expect_output_on(task.build_task_runs.last)
      end
    end

    context "when it was a failure" do
      let(:failed) { true }

      it "marks the task run failed and the task failed, even if there are still other runs running" do
        expect(CompleteTask.new(task_id: task.id, runner_name: runner_names.last, output: output, exit_code: exit_code, failed: failed).call).to eq(task)

        task.reload
        expect(task.state).to eq("failed")
        expect(task.build_task_runs.last.state).to eq("failed")
        expect(task.build_task_runs.last.finished_at).not_to be_blank
        expect_output_on(task.build_task_runs.last)
      end
    end
  end
end
