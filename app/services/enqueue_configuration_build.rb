class EnqueueConfigurationBuild
  attr_reader :configuration

  def initialize(configuration)
    @configuration = configuration
  end

  def call(trigger_params)
    configuration.transaction do
      build = configuration.configuration_builds.create!(trigger_params)
      build.build_tasks.create!(stage: "bootstrap", workers_to_run: 1)
      build
    end
  end
end
