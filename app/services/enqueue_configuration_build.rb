class EnqueueConfigurationBuild
  DEPLOYS_PATH = "#{Rails.root}/builds"

  attr_reader :configuration

  def initialize(configuration)
    @configuration = configuration
  end

  def call(trigger_params)
    configuration.transaction do
      @build = configuration.configuration_builds.create!(trigger_params)

      create_build_dir

      @build.configuration.components.each do |component|
        puts "***"
        puts component.container_name
        repo = component.repository

        get_code(repo)
        build_docker_image(repo)
      end

      #build.build_tasks.create!(stage: "bootstrap", workers_to_run: 1)
      #build
    end
  end

  private

  def build_docker_image(repo)
    Docker::Image.build_from_dir(deploy_repo_path + "/#{repo.name}")
  end

  def get_code(repo)
    # TODO: just pull the latest copy from cache instead of recloning
    begin
      git = Git.clone(repo.uri, repo.name, path: deploy_repo_path)
      # TODO: should grab the sha1sum that I actually want
      git_object = git.object('master')
    rescue Git::GitExecuteError
      # TODO: this will break :/
      @build.update_attributes! git_object_invalid: true
      raise "Exit job because the git object does not exist"
    end
  end

  def deploy_build_path
    "#{DEPLOYS_PATH}/#{@build.id}"
  end

  def deploy_repo_path
    "#{deploy_build_path}/repo"
  end

  def create_build_dir
    cleanup_build_dir
    system("mkdir -p #{deploy_repo_path}")
  end

  def cleanup_build_dir
    if File.exists?(deploy_build_path)
      system("rm -rf #{deploy_build_path}")
    end
  end
end
