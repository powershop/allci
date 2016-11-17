class ProcessGitPushEvent
  def call
    return unless repository.present?
  end

  def default_name
    # Repository will figure it out by default
  end

  def repository
    @repository ||= Repository.find_by_uri(uri) || Repository.create!(uri: uri, name: default_name) if uri
  end
end
