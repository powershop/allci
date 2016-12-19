class EnqueueConfigurationBuild
  attr_reader :configuration

  def initialize(configuration)
    @configuration = configuration
  end

  def call(trigger_params)
    configuration.transaction do
      build = configuration.configuration_builds.create!(trigger_params)
      build.build_tasks.create!(stage: 'bootstrap')
      build
    end
  end
end
