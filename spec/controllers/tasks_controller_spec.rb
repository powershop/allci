require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe "#pull" do
    it "receives queue pull requests and passes the data to AssignTask, returning the task in JSON format" do
      service = instance_double(AssignTask)
      build_task = instance_double(BuildTask)
      expect(AssignTask).to receive(:new).with(build_id: nil, stage: "build_component_images", runner_name: "foo-12:1").and_return(service)
      expect(service).to receive(:call).and_return(build_task)
      expect(build_task).to receive(:to_json).and_return("{ foo: 'bar' }")

      post :pull, params: { task: { id: "containers", stage: "build_component_images", runner_name: "foo-12:1" } }

      expect(response.status).to eq(200)
      expect(response.content_type).to eq("application/json")
      expect(response.body).to eq("{ foo: 'bar' }")
    end

    it "responds with the HTTP no content status if there is no task to run" do
      service = instance_double(AssignTask)
      expect(AssignTask).to receive(:new).with(build_id: nil, stage: "build_component_images", runner_name: "foo-12:1").and_return(service)
      expect(service).to receive(:call).and_return(nil)

      post :pull, params: { task: { id: "containers", stage: "build_component_images", runner_name: "foo-12:1" } }

      expect(response.status).to eq(204)
    end
  end
end
