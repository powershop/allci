shared_examples_for "git push event service" do
  it "uses the existing repository if it already exists" do
    repository = Repository.create!(uri: repository_uri)
    service.call
    expect(service.repository).to eq(repository)
  end

  it "creates the repository if it doesn't exist" do
    service.call
    expect(service.repository.uri).to eq(repository_uri)
    expect(service.repository.name).to eq(repository_name)
  end

  context "to a repository listed in project configurations" do
    let(:project1) { Project.create!(name: "Test project 1") }
    let(:project2) { Project.create!(name: "Test project 2") }
    let(:configuration1a) { project1.configurations.create!(name: "1a", build_priority: 100) }
    let(:configuration1b) { project1.configurations.create!(name: "1b", build_priority: 101) }
    let(:configuration2a) { project2.configurations.create!(name: "2a", build_priority: 100) }
    let(:configuration2b) { project2.configurations.create!(name: "2b", build_priority: 100) }
    let(:main_repository) { Repository.create!(uri: repository_uri) }
    let(:other_repository) { Repository.create!(uri: "git@github.com:willbryant/demo_project.git") }

    before do
      configuration1a.components.create!(repository: main_repository, branch: 'master')
      configuration1a.components.create!(repository: other_repository, branch: 'master')

      configuration1b.components.create!(repository: main_repository, branch: pushed_branch)
      configuration1b.components.create!(repository: other_repository, branch: 'master')

      configuration2a.components.create!(repository: main_repository, branch: pushed_branch)

      configuration2b.components.create!(repository: other_repository, branch: pushed_branch) # but note it's the wrong repo
    end

    it "queues a build for each configuration that includes the repository" do
      service.call

      expect(configuration1a.configuration_builds).to be_empty

      expect(configuration1b.configuration_builds.size).to eq(1)
      expect(configuration1b.configuration_builds.first.triggered_by_repository).to eq(main_repository)
      expect(configuration1b.configuration_builds.first.triggered_by_commit).to eq(pushed_commit)

      expect(configuration2a.configuration_builds.size).to eq(1)
      expect(configuration2a.configuration_builds.first.triggered_by_repository).to eq(main_repository)
      expect(configuration2a.configuration_builds.first.triggered_by_commit).to eq(pushed_commit)

      expect(configuration2b.configuration_builds).to be_empty
    end

    it "doesn't queue a build for configurations that aren't built by default" do
      configuration1b.update!(build_priority: nil)

      service.call

      expect(configuration1b.configuration_builds).to be_empty
    end

    it "doesn't queue a build for components that don't trigger builds" do
      configuration1b.components.where(repository: main_repository).take.update!(triggers_builds: false)

      service.call

      expect(configuration1b.configuration_builds).to be_empty
      expect(configuration2a.configuration_builds).to_not be_empty
    end
  end
end