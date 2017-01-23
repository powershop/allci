require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe "#pull" do
    it "receives queue pull requests and passes the data to AssignTask, returning the task in JSON format" do
      service = instance_double(AssignTask)
      build_task = instance_double(BuildTask)
      expect(AssignTask).to receive(:new).with(build_id: nil, stage: nil, runner_name: "foo-12:1").and_return(service)
      expect(service).to receive(:call).and_return(build_task)
      expect(build_task).to receive(:to_json).and_return("{ foo: 'bar' }")

      post :pull, params: { task: { build_id: nil, stage: nil, runner_name: "foo-12:1" } }

      expect(response.status).to eq(200)
      expect(response.content_type).to eq("application/json")
      expect(response.body).to eq("{ foo: 'bar' }")
    end

    it "responds with the HTTP no content status if there is no task to run" do
      service = instance_double(AssignTask)
      expect(AssignTask).to receive(:new).with(build_id: nil, stage: nil, runner_name: "foo-12:1").and_return(service)
      expect(service).to receive(:call).and_return(nil)

      post :pull, params: { task: { build_id: nil, stage: nil, runner_name: "foo-12:1" } }

      expect(response.status).to eq(204)
    end
  end

  describe "#success" do
    it "receives queue pull requests and passes the data to CompleteTask" do
      service = instance_double(CompleteTask)
      build_task = instance_double(BuildTask)
      expect(CompleteTask).to receive(:new).with(task_id: "1234", runner_name: "foo-12:1", output: {"container1" => "task output here", "container2" => "more output"}, failed: false).and_return(service)
      expect(service).to receive(:call).and_return(build_task)

      post :success, params: { task: { task_id: "1234", runner_name: "foo-12:1", output: {"container1" => "task output here", "container2" => "more output"} } }

      expect(response.status).to eq(200)
    end
  end

  describe "#failed" do
    it "receives queue pull requests and passes the data to CompleteTask" do
      service = instance_double(CompleteTask)
      build_task = instance_double(BuildTask)
      expect(CompleteTask).to receive(:new).with(task_id: "1234", runner_name: "foo-12:1", output: {"container1" => "task output here", "container2" => "more output"}, failed: true).and_return(service)
      expect(service).to receive(:call).and_return(build_task)

      post :failed, params: { task: { task_id: "1234", runner_name: "foo-12:1", output: {"container1" => "task output here", "container2" => "more output"} } }

      expect(response.status).to eq(200)
    end
  end
end
