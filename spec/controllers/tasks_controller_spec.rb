require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe "#pull" do
    it "receives queue pull requests and passes the data to AssignTask, returning the task in JSON format" do
      service = instance_double(AssignTask)
      build_task = instance_double(BuildTask)
      expect(AssignTask).to receive(:new).with(build_id: nil, stage: "bootstrap", runner_name: "foo-12:1").and_return(service)
      expect(service).to receive(:call).and_return(build_task)
      expect(build_task).to receive(:to_json).and_return("{ foo: 'bar' }")

      post :pull, params: { build_id: nil, stage: "bootstrap", runner_name: "foo-12:1" }

      expect(response.status).to eq(200)
      expect(response.content_type).to eq("application/json")
      expect(response.body).to eq("{ foo: 'bar' }")
    end

    it "allows multiple stages to be passed in an array" do
      service = instance_double(AssignTask)
      build_task = instance_double(BuildTask)
      expect(AssignTask).to receive(:new).with(build_id: nil, stage: %w(bootstrap spawn), runner_name: "foo-12:1").and_return(service)
      expect(service).to receive(:call).and_return(build_task)
      expect(build_task).to receive(:to_json).and_return("{ foo: 'bar' }")

      post :pull, params: { build_id: nil, stage: %w(bootstrap spawn), runner_name: "foo-12:1" }

      expect(response.status).to eq(200)
      expect(response.content_type).to eq("application/json")
      expect(response.body).to eq("{ foo: 'bar' }")
    end

    it "responds with the HTTP no content status if there is no task to run" do
      service = instance_double(AssignTask)
      expect(AssignTask).to receive(:new).with(build_id: nil, stage: "bootstrap", runner_name: "foo-12:1").and_return(service)
      expect(service).to receive(:call).and_return(nil)

      post :pull, params: { build_id: nil, stage: "bootstrap", runner_name: "foo-12:1" }

      expect(response.status).to eq(204)
    end
  end

  describe "#output" do
    it "receives task output and passes the data to StoreTaskOutput" do
      service = instance_double(StoreTaskOutput)
      build_task = instance_double(BuildTask)
      expect(StoreTaskOutput).to receive(:new).with(task_id: "1234", runner_name: "foo-12:1", output: {"container1" => "task output here", "container2" => "more output"}).and_return(service)
      expect(service).to receive(:call).and_return(build_task)

      post :output, params: { task_id: "1234", runner_name: "foo-12:1", output: {"container1" => "task output here", "container2" => "more output"} }

      expect(response.status).to eq(200)
    end
  end

  describe "#success" do
    it "receives task completion requests and passes the data to CompleteTask" do
      service = instance_double(CompleteTask)
      build_task = instance_double(BuildTask)
      expect(CompleteTask).to receive(:new).with(task_id: "1234", runner_name: "foo-12:1", output: {"container1" => "task output here", "container2" => "more output"}, exit_code: {"container1" => "127", "container2" => "0"}, failed: false).and_return(service)
      expect(service).to receive(:call).and_return(build_task)

      post :success, params: { task_id: "1234", runner_name: "foo-12:1", output: {"container1" => "task output here", "container2" => "more output"}, exit_code: {"container1" => 127, "container2" => 0} }

      expect(response.status).to eq(200)
    end
  end

  describe "#failed" do
    it "receives task completion requests and passes the data to CompleteTask" do
      service = instance_double(CompleteTask)
      build_task = instance_double(BuildTask)
      expect(CompleteTask).to receive(:new).with(task_id: "1234", runner_name: "foo-12:1", output: {"container1" => "task output here", "container2" => "more output"}, exit_code: {"container1" => "127", "container2" => "0"}, failed: true).and_return(service)
      expect(service).to receive(:call).and_return(build_task)

      post :failed, params: { task_id: "1234", runner_name: "foo-12:1", output: {"container1" => "task output here", "container2" => "more output"}, exit_code: {"container1" => 127, "container2" => 0} }

      expect(response.status).to eq(200)
    end
  end

  describe "#add" do
    it "accepts tasks as an array and creates a build task for each entry" do
      service = instance_double(AddTasks)
      first_task = instance_double(BuildTask)
      second_task = instance_double(BuildTask)
      expect(AddTasks).to receive(:new).with(build_id: "1234", stage: "run_tests", tasks: ["first task", "second task"], workers_to_run: nil).and_return(service)
      expect(service).to receive(:call).and_return([first_task, second_task])

      post :add, params: { build_id: "1234", stage: "run_tests", tasks: ["first task", "second task"] }

      expect(response.status).to eq(200)
    end

    it "accepts a single task and creates a build task for it" do
      service = instance_double(AddTasks)
      task = instance_double(BuildTask)
      expect(AddTasks).to receive(:new).with(build_id: "1234", stage: "run_tests", tasks: ["this is the task"], workers_to_run: nil).and_return(service)
      expect(service).to receive(:call).and_return([task])

      post :add, params: { build_id: "1234", stage: "run_tests", task: "this is the task" }

      expect(response.status).to eq(200)
    end

    it "accepts tasks as newline-terminated string and creates a build task for each line" do
      service = instance_double(AddTasks)
      first_task = instance_double(BuildTask)
      second_task = instance_double(BuildTask)
      expect(AddTasks).to receive(:new).with(build_id: "1234", stage: "run_tests", tasks: ["first task", "second task"], workers_to_run: nil).and_return(service)
      expect(service).to receive(:call).and_return([first_task, second_task])

      request.env['RAW_POST_DATA'] = "first task\nsecond task\n"
      post :add, params: { build_id: "1234", stage: "run_tests" }

      expect(response.status).to eq(200)
    end
  end
end
