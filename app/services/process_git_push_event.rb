class ProcessGitPushEvent
  def call
    return unless uri.present?

    Repository.transaction do
      repository.configurations.merge(Component.for_branch(branch)).build_by_default.in_build_priority_order.each do |configuration|
        EnqueueConfigurationBuild.new(configuration).call(triggered_by_repository: repository, triggered_by_commit: head_commit)
      end
    end
  end

  def default_name
    # Repository will figure it out by default
  end

  def repository
    @repository ||= Repository.find_by_uri(uri) || Repository.create!(uri: uri, name: default_name) if uri
  end
end
