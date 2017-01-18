require 'rails_helper'

RSpec.describe ConfigurationBuild, type: :model do
  describe "image_name_for" do
    let(:project) { Project.create!(name: "Test project 1") }
    let(:configuration) { project.configurations.create!(name: "Normal config", build_priority: 100) }

    let(:app_repository) { Repository.create!(uri: "git@github.com:willbryant/demo_project.git") }
    let(:app_component) { configuration.components.create!(repository: app_repository, container_name: "myapp")}

    let(:db_repository) { Repository.create!(uri: "git@github.com:willbryant/demo_db_project.git") }
    let(:db_component) { configuration.components.create!(repository: db_repository, container_name: "db")}

    let(:configuration_build) { configuration.configuration_builds.create!(state: "available") }

    it "names images based on the project name, build ID, and component container name" do
      expect(configuration_build.image_name_for(app_component)).to eq("Test_project_1-myapp:build-#{configuration_build.id}")
      expect(configuration_build.image_name_for(db_component)).to eq("Test_project_1-db:build-#{configuration_build.id}")
    end
  end
end
