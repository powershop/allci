require 'rails_helper'

RSpec.describe BuildTask, type: :model do
  let(:project) { Project.create!(name: "Test project 1") }
  let(:configuration) { project.configurations.create!(name: "Normal config", build_priority: 100) }

  let(:app_repository) { Repository.create!(uri: "git@github.com:willbryant/demo_project.git") }
  let(:app_component) { configuration.components.create!(repository: app_repository, container_name: "myapp", branch: "mytopic").tap { |c| c.component_variables.create!(name: 'Country', value: 'NZ'); c.component_variables.build_arg.create!(name: 'PORT_TO_EXPOSE', value: 3307) } }

  let(:db_repository) { Repository.create!(uri: "git@github.com:willbryant/demo_db_project.git") }
  let(:db_component) { configuration.components.create!(repository: db_repository, container_name: "db", tmpfs: "/var/lib/mysql:size=256m") }

  let(:configuration_build) { configuration.configuration_builds.create!(state: "available") }
  let(:build_task) { configuration_build.build_tasks.create!(state: "available", workers_to_run: 1, stage: "bootstrap", task: "build_component_images") }

  before do
    app_component
    db_component
  end

  describe "as_json" do
    it "gives the list of all components and their images" do
      expect(build_task.as_json).to eq({
        task_id: build_task.id,
        build_id: configuration_build.id,
        stage: "bootstrap",
        task: "build_component_images",
        configuration_name: "Normal config",
        components: {
          "db" => {
            repository_name: "Demo db project",
            repository_uri: db_repository.uri,
            branch: db_component.branch,
            dockerfile: db_component.dockerfile,
            image_name: configuration_build.image_name_for(db_component),
            runtime_env: {},
            build_args: {},
            tmpfs: "/var/lib/mysql:size=256m",
          },
          "myapp" => {
            repository_name: "Demo project",
            repository_uri: app_repository.uri,
            branch: app_component.branch,
            dockerfile: app_component.dockerfile,
            image_name: configuration_build.image_name_for(app_component),
            runtime_env: {
              'Country' => 'NZ',
            },
            build_args: {
              'PORT_TO_EXPOSE' => '3307',
            },
            tmpfs: nil,
          },
        }
      })
    end
  end
end
